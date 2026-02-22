import Foundation
import SwiftData

/// Represents the core educational categories in VirtuaLearn (MEB Temel Eğitim)
enum SubjectCategory: String, CaseIterable, Identifiable, Codable {
    case science = "Fen Bilimleri"
    case math = "Matematik"
    case socialStudies = "Sosyal Bilgiler"
    
    var id: String { self.rawValue }
    
    var englishName: String {
        switch self {
        case .science: return "Science"
        case .math: return "Math"
        case .socialStudies: return "Social Studies"
        }
    }
    
    var iconName: String {
        switch self {
        case .science: return "leaf.fill"
        case .math: return "x.squareroot"
        case .socialStudies: return "globe.europe.africa.fill"
        }
    }
}

/// A specific interactive point of interest on a 3D model.
struct Hotspot: Codable, Hashable {
    var id: String
    var title: String // e.g., "Kloroplast"
    var en_title: String // e.g., "Chloroplast"
    var description: String
    var en_description: String
    var x: Float
    var y: Float
    var z: Float
}

/// The core SwiftData model representing a 3D Educational Concept.
@Model
final class ARConcept {
    @Attribute(.unique) var id: UUID
    var title: String
    var en_title: String
    var conceptDescription: String
    var en_conceptDescription: String
    var detailedDescription: String 
    var en_detailedDescription: String 
    var imageName: String 
    var usdzFileName: String
    var categoryRawValue: String
    var isFavorite: Bool
    
    // Arrays for JSON decoding/encoding complex objects in SwiftData
    var hotspotsData: Data? 
    
    @Transient
    var hotspots: [Hotspot] {
        get {
            guard let data = hotspotsData else { return [] }
            return (try? JSONDecoder().decode([Hotspot].self, from: data)) ?? []
        }
        set {
            hotspotsData = try? JSONEncoder().encode(newValue)
        }
    }
    
    @Transient
    var category: SubjectCategory {
        get { SubjectCategory(rawValue: categoryRawValue) ?? .science }
        set { categoryRawValue = newValue.rawValue }
    }
    
    init(id: UUID = UUID(), title: String, en_title: String, conceptDescription: String, en_conceptDescription: String, detailedDescription: String, en_detailedDescription: String, imageName: String = "placeholder", usdzFileName: String, category: SubjectCategory, isFavorite: Bool = false, hotspots: [Hotspot] = []) {
        self.id = id
        self.title = title
        self.en_title = en_title
        self.conceptDescription = conceptDescription
        self.en_conceptDescription = en_conceptDescription
        self.detailedDescription = detailedDescription
        self.en_detailedDescription = en_detailedDescription
        self.imageName = imageName
        self.usdzFileName = usdzFileName
        self.categoryRawValue = category.rawValue
        self.isFavorite = isFavorite
        self.hotspots = hotspots
    }
}
