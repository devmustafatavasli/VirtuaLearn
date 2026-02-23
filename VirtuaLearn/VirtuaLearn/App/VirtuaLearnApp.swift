import SwiftUI
import SwiftData

@main
struct VirtuaLearnApp: App {
    @State private var appState = AppState()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    
    var body: some Scene {
        WindowGroup {
            let locale = Locale(identifier: appState.isLanguageEnglish ? "en" : "tr")
            if !hasSeenOnboarding {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    .environment(appState)
                    .environment(\.locale, locale)
            } else if appState.isARSupported {
                DashboardView()
                    .environment(appState)
                    .environment(\.locale, locale)
            } else {
                Text("AR capabilities not supported on this device.")
                    .environment(\.locale, locale)
            }
        }
        .modelContainer(for: [ARConcept.self])
    }
}
