import SwiftUI

/// Defines the global, educational-friendly color scheme for VirtuaLearn
struct AppTheme {
    static let primaryBackground = Color(UIColor.systemGroupedBackground)
    static let cardBackground = Color(UIColor.secondarySystemGroupedBackground)
    static let accentPrimary = Color(UIColor.systemBlue)
    
    // Subject specific colors (using iOS adaptive system colors)
    static func color(for category: SubjectCategory) -> Color {
        switch category {
        case .science: return Color(UIColor.systemGreen)
        case .math: return Color(UIColor.systemBlue)
        case .socialStudies: return Color(UIColor.systemOrange)
        }
    }
}
