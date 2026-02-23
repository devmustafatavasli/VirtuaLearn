import Foundation
import RealityKit

final class AssetLoader {
    /// Loads an ARConcept's 3D model either from the Main Bundle or the app's Documents directory.
    static func loadModelAsync(for concept: ARConcept) async throws -> ModelEntity {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let url: URL?
                
                if concept.isUserGenerated, let customPath = concept.customUsdzPath {
                    url = StorageManager.shared.getModelURL(for: customPath)
                } else {
                    url = Bundle.main.url(forResource: concept.usdzFileName, withExtension: "usdz")
                }
                
                guard let validUrl = url else {
                    throw NSError(domain: "AssetLoader", code: 404, userInfo: [NSLocalizedDescriptionKey: "Model for '\(concept.title)' not found."])
                }
                
                let entity = try ModelEntity.loadModel(contentsOf: validUrl)
                
                // Automatically play all embedded animations in a continuous loop
                for animation in entity.availableAnimations {
                    entity.playAnimation(animation.repeat())
                }
                
                continuation.resume(returning: entity)
                
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
