import SwiftUI
import RealityKit
import ARKit

struct ARContentView: UIViewRepresentable {
    
    let arManager = ARManager.shared
    
    func makeUIView(context: Context) -> ARView {
        let view = arManager.arView
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ARContentView
        
        init(_ parent: ARContentView) {
            self.parent = parent
        }
        
        @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
            guard let arView = recognizer.view as? ARView else { return }
            let location = recognizer.location(in: arView)
            
            // 1. Check if we tapped an existing interactive entity (like a Hotspot)
            if let entity = arView.entity(at: location) {
                // If it has a custom name, it's one of our Hotspot spheres
                if !entity.name.isEmpty {
                    NotificationCenter.default.post(
                        name: NSNotification.Name("HotspotTapped"),
                        object: entity.name // The Hotspot ID
                    )
                    return // Stop here, don't place a new model
                }
            }
            
            // 2. If no entity was tapped, check if we tapped a physical flat surface to place the model
            if let result = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal).first {
                NotificationCenter.default.post(
                    name: NSNotification.Name("ARPlaneTapped"),
                    object: result.worldTransform
                )
            }
        }
    }
}
