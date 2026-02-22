import Foundation
import RealityKit

final class AssetLoader {
    static func loadModelAsync(resourceName: String) async throws -> ModelEntity {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let url = Bundle.main.url(forResource: resourceName, withExtension: "usdz")
                
                guard let validUrl = url else {
                    throw NSError(domain: "AssetLoader", code: 404, userInfo: [NSLocalizedDescriptionKey: "Model '\(resourceName).usdz' not found. Please add the 3D asset to the project."])
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
