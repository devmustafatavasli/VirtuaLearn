import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    
    var body: some View {
        TabView {
            // Page 1
            OnboardingPage(
                imageName: "hand.wave.fill",
                title: "Welcome to VirtuaLearn",
                description: "Experience education like never before. Dive into subjects using Augmented Reality.",
                color: .blue
            )
            
            // Page 2
            OnboardingPage(
                imageName: "viewfinder",
                title: "Scan your Environment",
                description: "Find a flat, well-lit surface and place 3D educational models right in your room.",
                color: .orange
            )
            
            // Page 3
            VStack(spacing: 40) {
                Image(systemName: "hand.tap.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                
                VStack(spacing: 16) {
                    Text("Learn Interactively")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("Tap on glowing hotspots to hear detailed, bilingual explanations of concepts.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 32)
                }
                
                Button(action: {
                    withAnimation {
                        hasSeenOnboarding = true
                    }
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppTheme.accentPrimary)
                        .cornerRadius(16)
                        .padding(.horizontal, 32)
                }
                .padding(.top, 20)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .background(AppTheme.primaryBackground.ignoresSafeArea())
    }
}

struct OnboardingPage: View {
    let imageName: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 40) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(color)
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 32)
            }
        }
    }
}
