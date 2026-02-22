import Foundation
import RealityKit

final class AssetLoader {
    static func loadModelAsync(resourceName: String) async throws -> ModelEntity {
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let url = Bundle.main.url(forResource: resourceName, withExtension: "usdz")
                
                guard let validUrl = url else {
                    fatalError("Could not find \(resourceName).usdz in the app bundle.")
                }
                
                let entity = try ModelEntity.loadModel(contentsOf: validUrl)
                continuation.resume(returning: entity)
                
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
