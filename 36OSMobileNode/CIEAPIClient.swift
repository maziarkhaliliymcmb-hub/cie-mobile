import Foundation
import Security
import SwiftUI

enum SecureTokenStore {
    private static let service = "com.maziar.36os-mobile-node"
    private static let account = "cie-api-token"

    static func read() -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &result) == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else { return "" }
        return value
    }

    static func write(_ token: String) throws {
        let data = Data(token.utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        let update: [String: Any] = [kSecValueData as String: data,
                                     kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly]
        let status = SecItemUpdate(query as CFDictionary, update as CFDictionary)
        if status == errSecItemNotFound {
            var insert = query
            update.forEach { insert[$0.key] = $0.value }
            let addStatus = SecItemAdd(insert as CFDictionary, nil)
            guard addStatus == errSecSuccess else { throw SecureStoreError.status(addStatus) }
        } else if status != errSecSuccess {
            throw SecureStoreError.status(status)
        }
    }

    static func delete() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        SecItemDelete(query as CFDictionary)
    }
}

enum SecureStoreError: Error {
    case status(OSStatus)
}

enum CIEConnectionState: Equatable {
    case notConfigured
    case checking
    case connected(String)
    case failed(String)

    var label: String {
        switch self {
        case .notConfigured: return "Not configured"
        case .checking: return "Checking connection…"
        case .connected(let detail): return "Connected · \(detail)"
        case .failed(let reason): return "Connection failed · \(reason)"
        }
    }
}

enum CIEAPIError: LocalizedError {
    case invalidBaseURL
    case missingToken
    case nonHTTPResponse
    case httpStatus(Int, String)

    var errorDescription: String? {
        switch self {
        case .invalidBaseURL: return "Enter a valid HTTPS CIE URL."
        case .missingToken: return "A scoped CIE API token is required."
        case .nonHTTPResponse: return "The server returned an invalid response."
        case .httpStatus(let code, let detail): return "HTTP \(code): \(detail)"
        }
    }
}

struct CIEAPIClient {
    let baseURL: URL
    let token: String
    let session: URLSession

    init(baseURL: URL, token: String, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.token = token
        self.session = session
    }

    private func get(_ path: [String]) async throws -> (Data, HTTPURLResponse) {
        let url = path.reduce(baseURL) { $0.appendingPathComponent($1) }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 20
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw CIEAPIError.nonHTTPResponse }
        guard (200..<300).contains(http.statusCode) else {
            let body = String(data: data.prefix(512), encoding: .utf8) ?? "No response detail"
            throw CIEAPIError.httpStatus(http.statusCode, body)
        }
        return (data, http)
    }

    func healthCheck() async throws -> String {
        guard !token.isEmpty else { throw CIEAPIError.missingToken }
        // Authenticate first; the health endpoint alone is not an identity check.
        let (identityData, _) = try await get(["v1", "agents", "identity"])
        guard
            let identity = try JSONSerialization.jsonObject(with: identityData) as? [String: Any],
            let modelID = identity["model_id"] as? String,
            let scopes = identity["scopes"] as? [String]
        else {
            throw CIEAPIError.nonHTTPResponse
        }
        let (_, healthResponse) = try await get(["v1", "36os", "knowledge", "health"])
        return "\(modelID) · \(scopes.count) scopes · HTTP \(healthResponse.statusCode)"
    }
}

@MainActor
final class ConnectionSettings: ObservableObject {
    @Published var baseURL: String {
        didSet { UserDefaults.standard.set(baseURL, forKey: "36os.cie.base-url") }
    }
    @Published var tokenDraft: String = ""
    @Published private(set) var hasSavedToken: Bool
    @Published private(set) var state: CIEConnectionState = .notConfigured

    init() {
        self.baseURL = UserDefaults.standard.string(forKey: "36os.cie.base-url")
            ?? ""
        self.hasSavedToken = !SecureTokenStore.read().isEmpty
    }

    func saveToken() {
        do {
            try SecureTokenStore.write(tokenDraft.trimmingCharacters(in: .whitespacesAndNewlines))
            tokenDraft = ""
            hasSavedToken = !SecureTokenStore.read().isEmpty
            state = .notConfigured
        } catch {
            state = .failed("Secure storage error")
        }
    }

    func removeToken() {
        SecureTokenStore.delete()
        tokenDraft = ""
        hasSavedToken = false
        state = .notConfigured
    }

    func testConnection() async {
        guard let url = URL(string: baseURL),
              url.scheme == "https",
              url.host != nil else {
            state = .failed(CIEAPIError.invalidBaseURL.localizedDescription)
            return
        }
        let token = SecureTokenStore.read()
        guard !token.isEmpty else {
            state = .failed(CIEAPIError.missingToken.localizedDescription)
            return
        }
        state = .checking
        do {
            let detail = try await CIEAPIClient(baseURL: url, token: token).healthCheck()
            state = .connected(detail)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
