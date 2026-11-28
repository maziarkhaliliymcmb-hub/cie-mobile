import Foundation
#if canImport(FoundationModels)
import FoundationModels
#endif

/// Apple Foundation Models adapter. Kept behind the provider contract so it can
/// be replaced by LiteRT-LM or another verified on-device runtime without changing UI.
@MainActor
final class FoundationModelsProvider: LocalInferenceProvider {
    let identifier = "apple.foundation-models"
    let displayName = "Apple Foundation Models"

    func availability() -> LocalProviderAvailability {
        #if canImport(FoundationModels)
        if #available(iOS 26.0, *) {
            switch SystemLanguageModel.default.availability {
            case .available:
                return LocalProviderAvailability(isAvailable: true, detail: "On-device model available")
            case .unavailable(let reason):
                return LocalProviderAvailability(
                    isAvailable: false,
                    detail: "Unavailable: \(String(describing: reason))"
                )
            }
        }
        return LocalProviderAvailability(isAvailable: false, detail: "Requires iOS 26 or later")
        #else
        return LocalProviderAvailability(
            isAvailable: false,
            detail: "This build SDK does not include Foundation Models"
        )
        #endif
    }

    func generate(_ request: LocalInferenceRequest) async throws -> LocalInferenceResponse {
        #if canImport(FoundationModels)
        guard #available(iOS 26.0, *) else {
            throw LocalInferenceError.providerUnavailable("Requires iOS 26 or later.")
        }
        let state = availability()
        guard state.isAvailable else {
            throw LocalInferenceError.providerUnavailable(state.detail)
        }

        let start = Date()
        do {
            let session = LanguageModelSession(instructions: request.systemInstructions)
            let response = try await session.respond(to: request.prompt)
            return LocalInferenceResponse(
                text: response.content,
                providerID: identifier,
                modelID: "system-managed",
                elapsedMilliseconds: Int(Date().timeIntervalSince(start) * 1_000)
            )
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            throw LocalInferenceError.providerFailure(error.localizedDescription)
        }
        #else
        throw LocalInferenceError.providerUnavailable("Foundation Models is not available in this build.")
        #endif
    }
}
