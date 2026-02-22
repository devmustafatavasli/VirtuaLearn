import SwiftUI

/// Defines the global, educational-friendly color scheme for VirtuaLearn
struct AppTheme {
    static let primaryBackground = Color(UIColor.systemGroupedBackground)
    static let cardBackground = Color(UIColor.secondarySystemGroupedBackground)
    
    // Subject specific colors
    static func color(for category: SubjectCategory) -> Color {
        switch category {
        case .science: return .green
        case .math: return .blue
        case .socialStudies: return .orange
        }
    }
}
