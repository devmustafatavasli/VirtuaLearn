import SwiftUI
import RealityKit

struct CaptureSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var processModel = ObjectCaptureProcessModel()
    
    var body: some View {
        NavigationStack {
            Group {
                switch processModel.currentState {
                case .notSupported:
                    UnsupportedDeviceView()
                    
                case .notStarted:
                    CapturePreparationView(onStart: {
                        processModel.startCaptureSession()
                    })
                    
                case .preparing, .capturing:
                    #if os(iOS) && !targetEnvironment(simulator)
                    if let session = processModel.session {
                        ZStack(alignment: .bottom) {
                            ObjectCaptureView(session: session)
                                .edgesIgnoringSafeArea(.all)
                            
                            VStack(spacing: 16) {
                                if case .preparing = processModel.currentState {
                                    Button(action: { processModel.startCamera() }) {
                                        Text("I'm Ready!")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.blue)
                                            .cornerRadius(12)
                                    }
                                } else if case .capturing = processModel.currentState {
                                    Button(action: { processModel.finishCaptureAndProcess() }) {
                                        Text("Finish & Process")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.green)
                                            .cornerRadius(12)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(16)
                            .padding()
                        }
                    } else {
                        ProgressView("Initializing Camera...")
                    }
                    #else
                    Text("Capture cannot run on Simulator.")
                    #endif
                    
                case .processing:
                    VStack(spacing: 24) {
                        ProgressView()
                            .scaleEffect(2.0)
                        Text("Creating Magic 3D Object...")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("This can take a few minutes. Please don't close the app!")
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    
                case .success(let path):
                    CaptureSaveView(usdzPath: path) {
                        dismiss()
                    }
                    
                case .failed(let error):
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.red)
                        Text("Capture Failed")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(error)
                            .multilineTextAlignment(.center)
                            .padding()
                        Button("Try Again") {
                            processModel.cleanup()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationTitle(processModel.currentState == .notStarted ? "Create 3D Object" : "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        processModel.cleanup()
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Subviews

struct UnsupportedDeviceView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "cube.transparent")
                .font(.system(size: 80))
                .foregroundColor(.secondary)
            
            Text("LiDAR Required")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Creating 3D objects requires an iPad Pro or iPhone Pro with a LiDAR scanner (iPhone 12 Pro or newer).")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding()
    }
}
