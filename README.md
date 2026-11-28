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

## On-device local inference (iPhone)

The iOS app uses a provider-neutral local inference contract. The UI and engineering workflows depend on `LocalInferenceProvider`, not directly on a model SDK.

- Current registered provider: Apple Foundation Models, through the native `FoundationModels` framework.
- Next runtime candidate: Google's LiteRT-LM Swift SDK, selected for native iOS support, Metal/GPU acceleration, streaming, and tool-use APIs.
- The provider interface permits additional local runtimes without rewriting the UI or task orchestration.
- Current workload: bounded, advisory code QA on user-pasted excerpts (16 KB maximum).
- No silent cloud fallback. Provider selection is explicit.
- The local model has no shell, repository-write, test-runner, deployment, or merge capability.
- This stage does not submit source or results to CIE and does not register a Compute Node.

See [Local Inference Provider Architecture](docs/local-inference-provider-architecture.md) for the provider contract, LiteRT-LM evaluation gates, security boundaries, and non-goals.
