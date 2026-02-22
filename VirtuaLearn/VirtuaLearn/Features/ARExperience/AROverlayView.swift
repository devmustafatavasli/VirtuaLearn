import SwiftUI

struct AROverlayView: View {
    @State private var viewModel = ARViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let concept: ARConcept
    
    var body: some View {
        ZStack {
            ARContentView()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text(concept.title)
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                    
                    Spacer()
                    
                    Button(action: {
                        // Play Text to Speech
                    }) {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.title2)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 50)
                
                Spacer()
                
                if viewModel.isModelLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(.circular)
                        Text("Loading 3D Model...")
                            .font(.caption)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .padding(.bottom, 40)
                } else if let error = viewModel.currentError {
                    Text(error)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(8)
                        .padding(.bottom, 40)
                } else {
                    Text("Tap an empty surface to place the model.")
                        .font(.subheadline)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.prepareExperience(for: concept)
        }
        .onDisappear {
            viewModel.cleanup()
        }
    }
}
