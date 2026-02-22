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
            self.placeActiveModel(at: transform)
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
                let entity = try await AssetLoader.loadModelAsync(resourceName: concept.usdzFileName)
                arManager.placeEntity(entity, at: transform)
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
