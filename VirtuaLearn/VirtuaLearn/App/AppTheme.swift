import SwiftUI

/// Defines the global, educational-friendly color scheme for VirtuaLearn
struct AppTheme {
    static let primaryBackground = Color(UIColor.systemGroupedBackground)
    static let cardBackground = Color(UIColor.secondarySystemGroupedBackground)
    
    // Subject specific colors
    static func color(for category: SubjectCategory) -> Color {
        switch category {
        case .math: return .blue
        case .biology: return .green
        case .physics: return .purple
        case .chemistry: return .orange
        }
    }
}
