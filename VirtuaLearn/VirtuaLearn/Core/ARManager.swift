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
    
    func placeEntity(_ entity: ModelEntity, at transform: simd_float4x4, with hotspots: [Hotspot] = []) {
        // Create the main anchor and attach the 3D model
        let anchorEntity = AnchorEntity(world: transform)
        anchorEntity.addChild(entity)
        
        // Generate collision shapes for the main model so we can tap *it* too if needed
        entity.generateCollisionShapes(recursive: true)
        
        // --- NEW: Add Interactive Hotspots ---
        for hotspot in hotspots {
            // Create a small glowing blue sphere
            let sphere = MeshResource.generateSphere(radius: 0.02)
            var material = SimpleMaterial(color: .systemBlue, isMetallic: false)
            material.color.tint = .cyan
            
            let hotspotEntity = ModelEntity(mesh: sphere, materials: [material])
            
            // Name it after the hotspot ID so we can identify it on tap
            hotspotEntity.name = hotspot.id
            
            // Position it relative to the main entity's center
            hotspotEntity.position = SIMD3<Float>(hotspot.x, hotspot.y, hotspot.z)
            
            // Give it collision so RealityKit raycasting can detect taps
            hotspotEntity.generateCollisionShapes(recursive: true)
            
            // Attach the hotspot to the main model
            entity.addChild(hotspotEntity)
        }
        
        arView.scene.addAnchor(anchorEntity)
    }
    
    func cleanUpSession() {
        arView.scene.anchors.removeAll()
        arView.session.run(ARWorldTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
    }
}
