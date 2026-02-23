import Testing
import Foundation
@testable import VirtuaLearn

@Suite("App State Tests")
@MainActor
struct AppStateTests {
    @Test("App State initializes with correct defaults")
    func testDefaults() {
        let state = AppState()
        #expect(state.isLanguageEnglish == false)
        #expect(state.selectedCategory == nil)
    }
    
    @Test("App State language toggle works")
    func testLanguageToggle() {
        let state = AppState()
        state.isLanguageEnglish.toggle()
        #expect(state.isLanguageEnglish == true)
    }
}

@Suite("Audio Service Tests")
@MainActor
struct AudioServiceTests {
    @Test("Audio service toggle sets isSpeaking true")
    func testSpeak() {
        let audioService = AudioService.shared
        audioService.stop()
        
        audioService.speak(text: "Test")
        #expect(audioService.isSpeaking == true)
    }
}

@Suite("Subject Category Model Tests")
struct SubjectCategoryTests {
    @Test("Subject matching maps to appropriate icons and English names")
    func testCategoryMetadata() {
        #expect(SubjectCategory.science.englishName == "Science")
        #expect(SubjectCategory.science.iconName == "leaf.fill")
        
        #expect(SubjectCategory.math.englishName == "Math")
        #expect(SubjectCategory.socialStudies.englishName == "Social Studies")
    }
}

@Suite("Curriculum JSON Decoding Tests")
struct JSONDecodingTests {
    
    struct HotspotDTO: Codable {
        let id: String
        let title: String
        let en_title: String
        let description: String
        let en_description: String
        let x: Float
        let y: Float
        let z: Float
    }
    
    struct ConceptDTO: Codable {
        let id: String
        let title: String
        let en_title: String?
        let conceptDescription: String
        let en_conceptDescription: String?
        let detailedDescription: String
        let en_detailedDescription: String?
        let imageName: String
        let usdzFileName: String
        let categoryRawValue: String
        let isFavorite: Bool
        let hotspots: [HotspotDTO]?
    }
    
    @Test("JSON file exists and maps perfectly to DTOs")
    func testJSONDecoding() throws {
        // Find the bundle that contains the app resources (AudioService is a class in that module)
        let bundle = Bundle(for: AudioService.self)
        guard let url = bundle.url(forResource: "meb_curriculum_data", withExtension: "json") else {
            Issue.record("Could not find meb_curriculum_data.json in the bundle.")
            return
        }
        
        let data = try Data(contentsOf: url)
        let concepts = try JSONDecoder().decode([ConceptDTO].self, from: data)
        
        #expect(concepts.count == 8, "There should be exactly 8 concepts from the MEB Temel Eğitim catalog.")
        
        // Assert the first concept is Plant Cell and has hotspots mapped
        let plantCell = concepts.first(where: { $0.id == "A1B2C3D4-E5F6-4A5B-8C9D-0E1F2A3B4C5D" })
        #expect(plantCell != nil)
        #expect(plantCell?.title == "Hücre ve Organelleri")
        #expect(plantCell?.en_title == "Cell & Organelles")
        #expect(plantCell?.hotspots?.count == 2, "Plant Cell should have 2 placeholder hotspots")
        
        // Assert all SubjectCategory raw values are valid
        for concept in concepts {
            let validCategory = SubjectCategory(rawValue: concept.categoryRawValue)
            #expect(validCategory != nil, "Invalid category raw value found: \(concept.categoryRawValue)")
        }
    }
}
