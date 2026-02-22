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
                        if AudioService.shared.isSpeaking {
                            AudioService.shared.stop()
                        } else {
                            AudioService.shared.speak(text: concept.conceptDescription)
                        }
                    }) {
                        Image(systemName: AudioService.shared.isSpeaking ? "speaker.wave.3.fill" : "speaker.wave.2.fill")
                            .font(.title2)
                            .foregroundColor(AudioService.shared.isSpeaking ? .blue : .primary)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 50)
                
                Spacer()
                if viewModel.isModelLoading {
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .progressViewStyle(.circular)
                        Text("Loading 3D Model...")
                            .font(.headline)
                        Text("Please hold your device steady")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(24)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .padding(.bottom, 40)
                } else if let error = viewModel.currentError {
                    Text(error)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(12)
                        .padding(.bottom, 40)
                } else {
                    // Educational Context Card
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "hand.tap.fill")
                                .foregroundColor(.blue)
                            Text("Interactive AR Mode")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        
                        Text("1. Point your camera at a flat, well-lit surface.\n2. Tap the screen to place the \(concept.title).")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.ultraThinMaterial)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.prepareExperience(for: concept)
        }
        .onDisappear {
            viewModel.cleanup()
            AudioService.shared.stop()
        }
    }
}
