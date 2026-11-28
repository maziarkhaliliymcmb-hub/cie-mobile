import Foundation

enum LocalInferenceTask: String, CaseIterable {
    case codeAnalysis
    case codeGeneration
    case testDesign
    case debugging
}

struct LocalInferenceRequest {
    let task: LocalInferenceTask
    let systemInstructions: String
    let prompt: String
    let maximumInputBytes: Int

    func validate() throws {
        guard !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw LocalInferenceError.emptyPrompt
        }
        guard prompt.utf8.count <= maximumInputBytes else {
            throw LocalInferenceError.inputTooLarge(limit: maximumInputBytes)
        }
    }
}

struct LocalProviderAvailability {
    let isAvailable: Bool
    let detail: String
}

struct LocalInferenceResponse {
    let text: String
    let providerID: String
    let modelID: String
    let elapsedMilliseconds: Int
}

enum LocalInferenceError: LocalizedError {
    case emptyPrompt
    case inputTooLarge(limit: Int)
    case providerUnavailable(String)
    case providerFailure(String)
    case providerNotRegistered(String)

    var errorDescription: String? {
        switch self {
        case .emptyPrompt:
            return "The inference prompt is empty."
        case .inputTooLarge(let limit):
            return "Input exceeds the configured limit of \(limit) bytes."
        case .providerUnavailable(let detail):
            return detail
        case .providerFailure(let detail):
            return "Local inference failed: \(detail)"
        case .providerNotRegistered(let identifier):
            return "No local inference provider is registered as \(identifier)."
        }
    }
}

/// Runtime contract. Providers are local-only; cloud providers must use a separate,
/// explicitly authorized integration and must never be selected as a silent fallback.
@MainActor
protocol LocalInferenceProvider: AnyObject {
    var identifier: String { get }
    var displayName: String { get }
    func availability() -> LocalProviderAvailability
    func generate(_ request: LocalInferenceRequest) async throws -> LocalInferenceResponse
}

@MainActor
final class LocalInferenceRouter {
    private let providers: [any LocalInferenceProvider]
    private(set) var selectedProviderID: String

    init(providers: [any LocalInferenceProvider], selectedProviderID: String? = nil) {
        self.providers = providers
        self.selectedProviderID = selectedProviderID ?? providers.first?.identifier ?? ""
    }

    var selectedProvider: (any LocalInferenceProvider)? {
        providers.first { $0.identifier == selectedProviderID }
    }

    var registeredProviders: [any LocalInferenceProvider] {
        providers
    }

    func selectProvider(identifier: String) throws {
        guard providers.contains(where: { $0.identifier == identifier }) else {
            throw LocalInferenceError.providerNotRegistered(identifier)
        }
        selectedProviderID = identifier
    }

    func generate(_ request: LocalInferenceRequest) async throws -> LocalInferenceResponse {
        try request.validate()
        guard let provider = selectedProvider else {
            throw LocalInferenceError.providerUnavailable("No local inference provider is configured.")
        }
        let state = provider.availability()
        guard state.isAvailable else {
            throw LocalInferenceError.providerUnavailable(state.detail)
        }
        return try await provider.generate(request)
    }
}
