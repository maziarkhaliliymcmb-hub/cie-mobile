# iPhone on-device model v1

## Hardware and model decision

Target device: iPhone 16 Pro Max (A18 Pro). Apple lists iPhone 16 models among Apple Intelligence-capable devices. The phone's 256 GB storage is not the model's working memory; iOS manages available RAM and may terminate inference under memory pressure.

Initial model: Apple's OS-managed `SystemLanguageModel.default`, accessed through the native `FoundationModels` framework. This avoids an unsupported desktop runtime such as Ollama and avoids shipping a large GGUF file in the first milestone.

Runtime requirements:
- iOS 26 or later.
- Apple Intelligence enabled.
- The on-device model downloaded and available.
- Device and Siri languages configured to a supported language.
- Runtime availability checked before each inference session.

Apple's framework supports on-device text generation, structured output and tool calling. Apple positions its on-device model for language understanding and generation; more demanding reasoning and larger context workflows may require a stronger server model. Therefore, this initial use is bounded code QA, not autonomous software engineering.

## Architecture

```text
iPhone 16 Pro Max
  36OS Mobile Node (SwiftUI)
    LocalModelService
      FoundationModels / SystemLanguageModel.default
        Apple on-device model
    Existing CIEAPIClient
      authenticated identity + health check
  (future gated bridge)
    CIE analysis/task API
```

The inference path is local. The first milestone does not upload source code or model output. The app's existing CIE connection remains separate; no model is registered as a CIE agent and no new token scopes are required.

## Safety boundary

- Input capped at 16 KB for the first profile.
- Prompt explicitly treats source code and comments as untrusted data.
- No shell, filesystem, GitHub, test execution, deployment or merge tools.
- No silent cloud fallback.
- Results are advisory; deterministic CI and human review remain authoritative.
- The OS may report the model unavailable if Apple Intelligence is disabled, the model is still downloading, the device/region/language is unsupported, or resources are constrained.

## Device setup

1. Update iPhone to iOS 26 or later.
2. Open Settings → Apple Intelligence & Siri and enable Apple Intelligence.
3. Set device and Siri languages to a supported language (English is recommended for code QA; Persian is not currently listed by Apple as a supported Apple Intelligence language).
4. Keep the phone on Wi-Fi and power while the on-device model downloads.
5. Install the 36OS Mobile Node build and open Intelligence → Local Models.
6. Check availability, paste a small non-sensitive code excerpt, and run the local analysis.

## Next integration gate

After a successful on-device smoke test, define a CIE contract to register a device-local model identity and submit its analysis outputs. This must use a dedicated least-privilege scope and an explicit user action. The phone must not be treated as an always-on worker: iOS normally suspends apps in the background. Long-running background work is possible only through specific system-managed task APIs and remains conditional, not a persistent daemon.
