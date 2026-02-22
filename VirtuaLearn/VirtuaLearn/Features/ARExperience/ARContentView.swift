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
            
            if let result = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal).first {
                NotificationCenter.default.post(
                    name: NSNotification.Name("ARPlaneTapped"),
                    object: result.worldTransform
                )
            }
        }
    }
}
