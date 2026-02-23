import Foundation
import SwiftData
import Observation
import RealityKit

@Observable
@MainActor
final class ARViewModel {
    var isModelLoading: Bool = false
    var currentError: String? = nil
    var activeConcept: ARConcept?
    
    private let arManager = ARManager.shared
    
    init() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("ARPlaneTapped"), object: nil, queue: .main) { [weak self] notification in
            guard let self = self, let transform = notification.object as? simd_float4x4 else { return }
            Task { @MainActor in
                self.placeActiveModel(at: transform)
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("HotspotTapped"), object: nil, queue: .main) { [weak self] notification in
            guard let self = self,
                  let hotspotId = notification.object as? String,
                  let concept = self.activeConcept else { return }
            
            Task { @MainActor in
                if let matchedHotspot = concept.hotspots.first(where: { $0.id == hotspotId }) {
                    print("Tapped Hotspot: \(matchedHotspot.title)")
                    // Read the hotspot description, checking if the system is currently English vs Turkish
                    // Ideally we'd pass AppState into the ViewModel, but for now we fallback to the AudioService's auto-lang logic
                    let textToSpeak = AVSpeechSynthesisVoice.currentLanguageCode()?.hasPrefix("en") == true
                        ? matchedHotspot.en_description
                        : matchedHotspot.description
                    AudioService.shared.speak(text: textToSpeak)
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func prepareExperience(for concept: ARConcept) {
        self.activeConcept = concept
    }
    
    func placeActiveModel(at transform: simd_float4x4) {
        guard let concept = activeConcept else { return }
        
        Task {
            isModelLoading = true
            currentError = nil
            do {
                let entity = try await AssetLoader.loadModelAsync(for: concept)
                arManager.placeEntity(entity, at: transform, with: concept.hotspots)
            } catch {
                currentError = "Failed to load \(concept.title) model: \(error.localizedDescription)"
                print(currentError!)
            }
            isModelLoading = false
        }
    }
    
    func cleanup() {
        arManager.cleanUpSession()
        activeConcept = nil
    }
}
