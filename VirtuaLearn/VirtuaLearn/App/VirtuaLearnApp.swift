import SwiftUI
import SwiftData

@main
struct VirtuaLearnApp: App {
    @State private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            if appState.isARSupported {
                DashboardView()
                    .environment(appState)
            } else {
                Text("AR capabilities not supported on this device.")
            }
        }
        .modelContainer(for: [ARConcept.self])
    }
}
