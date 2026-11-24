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
