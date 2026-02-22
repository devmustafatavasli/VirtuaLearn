import Foundation
import SwiftData

/// Represents the core educational categories in VirtuaLearn
enum SubjectCategory: String, Codable, CaseIterable, Identifiable {
    case math = "Math"
    case biology = "Biology"
    case physics = "Physics"
    case chemistry = "Chemistry"
    
    var id: String { self.rawValue }
    
    var iconName: String {
        switch self {
        case .math: return "function"
        case .biology: return "leaf.fill"
        case .physics: return "atom"
        case .chemistry: return "flame.fill"
        }
    }
}

/// The core SwiftData model representing a 3D Educational Concept.
@Model
final class ARConcept {
    @Attribute(.unique) var id: UUID
    var title: String
    var conceptDescription: String
    var usdzFileName: String
    var categoryRawValue: String
    var isFavorite: Bool
    
    @Transient
    var category: SubjectCategory {
        get { SubjectCategory(rawValue: categoryRawValue) ?? .biology }
        set { categoryRawValue = newValue.rawValue }
    }
    
    init(id: UUID = UUID(), title: String, conceptDescription: String, usdzFileName: String, category: SubjectCategory, isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.conceptDescription = conceptDescription
        self.usdzFileName = usdzFileName
        self.categoryRawValue = category.rawValue
        self.isFavorite = isFavorite
    }
}
