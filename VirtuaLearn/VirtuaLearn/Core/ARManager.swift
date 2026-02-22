import Foundation
import ARKit
import RealityKit

@MainActor
final class ARManager {
    static let shared = ARManager()
    
    let arView: ARView
    
    private init() {
        self.arView = ARView(frame: .zero)
        setupARSession()
    }
    
    private func setupARSession() {
        let config = ARWorldTrackingConfiguration()
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        } else {
            config.planeDetection = [.horizontal, .vertical]
        }
        
        config.environmentTexturing = .automatic
        arView.session.run(config)
    }
    
    func placeEntity(_ entity: ModelEntity, at transform: simd_float4x4) {
        let anchorEntity = AnchorEntity(world: transform)
        anchorEntity.addChild(entity)
        
        entity.generateCollisionShapes(recursive: true)
        arView.scene.addAnchor(anchorEntity)
    }
    
    func cleanUpSession() {
        arView.scene.anchors.removeAll()
        arView.session.run(ARWorldTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
    }
}
