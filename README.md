# 36OS Mobile Node

Native iOS client foundation for the 36OS / CIE distributed compute ecosystem.

## Product decisions
- Hybrid Intelligence Interface
- Dark Intelligence theme
- Bilingual English / Persian UI with RTL support
- Manual information-density preference: Simple, Adaptive, Expert
- Home / Command Center as the default landing page
- Creator-first access model; future RBAC roles remain architecture-ready

## Project
Open the 36OSMobileNode.xcodeproj project in Xcode and select the 36OSMobileNode scheme.

- Minimum iOS: 16.0
- UI framework: SwiftUI
- App entry: 36OSMobileNode/App.swift
- Design tokens: 36OSMobileNode/DesignSystem.swift
- Localization: 36OSMobileNode/Localization.swift
- Screen foundations: 36OSMobileNode/Screens.swift

## Current implementation boundary
This commit provides the native app shell, five-section navigation, dark design tokens, bilingual labels, persisted manual density/language preferences, and page foundations.

It does not yet provide live CIE/36OS API integration, device registration, background worker execution, local model runtime, or production authentication. All service metrics are intentionally unavailable until a trusted API client is implemented.

No Supabase service-role key or internal CIE-to-36OS credential belongs in the mobile app. The app must communicate only with authenticated, scoped CIE endpoints.


## CIE connection client
- CIE API base URL is editable in System → Connection Settings.
- A scoped bearer token is stored in iOS Keychain (WhenUnlockedThisDeviceOnly).
- The app performs an authenticated read-only health check against `GET /v1/36os/knowledge/health`.
- Tokens are never written to UserDefaults or logged.
- The current client does not yet register or heartbeat a compute node. Those calls must wait until the corresponding authenticated CIE routes are implemented and deployed.

## iOS distribution without a paid Apple Developer membership
- `.github/workflows/sidestore-ipa-release.yml` builds an unsigned device archive, packages it as an IPA, and sends the IPA to the configured Telegram chat using the Bot API.
- This workflow requires only `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID` repository Actions secrets. The bot must have been started by the recipient, and the configured chat must be able to receive documents.
- The IPA is unsigned by design. SideStore signs it with the user's own Apple Account during installation; the IPA is not directly installable by tapping it in Telegram.
- SideStore's initial installation/pairing requires a computer once. A free Apple Account is limited to three active sideloaded apps including SideStore, and apps generally need refreshing within the 7-day signing period. See the official SideStore installation guide and FAQ.
- GitHub Actions workflow_dispatch can trigger the build and Telegram delivery. The workflow artifact is retained for seven days as a fallback.

## TestFlight distribution (optional later)
The separate `.github/workflows/testflight-release.yml` remains available if a paid Apple Developer Program membership is obtained later. It requires App Store Connect credentials, an App ID, and the TestFlight public link in addition to Telegram credentials.

## On-device local model (iPhone)

The first local inference implementation uses Apple's **Foundation Models** framework from the native SwiftUI app. On supported hardware and OS versions, the model runs on-device and can operate without a model-provider API key or a separate Ollama server.

- Target device: iPhone 16 Pro Max (Apple lists iPhone 16 models as Apple Intelligence-capable).
- Runtime: Apple's `FoundationModels` framework / `SystemLanguageModel.default`.
- Availability: iOS 26 or later, Apple Intelligence enabled, model downloaded and ready, and a supported device/Siri language configuration.
- First workload: bounded, advisory code QA on user-pasted excerpts (16 KB maximum).
- The local model has no shell, file, GitHub, test-runner, deployment, or merge capability.
- Source text stays in the app for this first proof of concept; this screen does not upload source or results to CIE.
- The model is an OS-managed general-purpose model, not a dedicated coding model. Treat its findings as hypotheses and verify with CI and deterministic tests.

Open Intelligence → Local Models in the app. The app checks runtime availability before inference. If the model is unavailable, it reports the platform reason rather than falling back to a cloud provider.

### CIE integration boundary

The native app already has a scoped CIE API client for authenticated identity and health checks. This first local-inference PR establishes the device runtime and UI only. Sending model results into CIE's analysis/task lifecycle is a separate integration gate: it requires a defined CIE agent identity, narrowly scoped token permissions, and a dedicated API contract. Do not grant the on-device model task-claim or repository-write privileges.
