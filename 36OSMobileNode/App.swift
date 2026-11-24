import SwiftUI

@main
struct ThirtySixOSMobileNodeApp: App {
    var body: some Scene {
        WindowGroup { RootView().preferredColorScheme(.dark) }
    }
}
struct RootView: View {
    @StateObject private var connection = ConnectionSettings()
    @AppStorage("36os.language") private var languageRaw = AppLanguage.english.rawValue
    @AppStorage("36os.density") private var densityRaw = InformationDensity.adaptive.rawValue
    private var language: AppLanguage { AppLanguage(rawValue: languageRaw) ?? .english }
    private var density: InformationDensity { InformationDensity(rawValue: densityRaw) ?? .adaptive }
    var body: some View {
        TabView {
            NavigationStack { HomeView(language: language, density: density) }
                .tabItem { Label(Copy.text("home", language), systemImage: "house.fill") }
            NavigationStack { ComputeView(language: language, density: density) }
                .tabItem { Label(Copy.text("compute", language), systemImage: "cpu") }
            NavigationStack { WorkersView(language: language, density: density) }
                .tabItem { Label(Copy.text("workers", language), systemImage: "point.3.connected.trianglepath.dotted") }
            NavigationStack { IntelligenceView(language: language, density: density) }
                .tabItem { Label(Copy.text("intelligence", language), systemImage: "brain.head.profile") }
            NavigationStack { SystemView(language: language, density: density, languageRaw: $languageRaw, densityRaw: $densityRaw) }
                .tabItem { Label(Copy.text("system", language), systemImage: "gearshape") }
        }
        .tint(DS.primary)
        .environment(\.layoutDirection, language.direction)
        .environmentObject(connection)
    }
}