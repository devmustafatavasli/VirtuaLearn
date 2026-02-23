import SwiftUI

struct CapturePreparationView: View {
    let onStart: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Image(systemName: "camera.macro")
                    .font(.system(size: 100))
                    .foregroundColor(AppTheme.accentSecondary)
                    .padding(.top, 40)
                
                Text("Let's capture a new object!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 16) {
                    TipRow(icon: "sun.max.fill", text: "Find a spot with lots of light.")
                    TipRow(icon: "eye.slash.fill", text: "Avoid shiny objects like glass or mirrors.")
                    TipRow(icon: "tortoise.fill", text: "Walk around the object very slowly.")
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                
                Spacer(minLength: 40)
                
                Button(action: onStart) {
                    Text("Start Scanning")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.accentPrimary)
                        .cornerRadius(16)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

struct TipRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(AppTheme.accentPrimary)
                .frame(width: 30)
            
            Text(text)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}
