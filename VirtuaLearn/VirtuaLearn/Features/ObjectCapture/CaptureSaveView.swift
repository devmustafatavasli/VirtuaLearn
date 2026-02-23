import SwiftUI
import SwiftData

struct CaptureSaveView: View {
    let usdzPath: String
    let onSaveCompete: () -> Void
    
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    
    @State private var objectName: String = ""
    @State private var selectedSubject: SubjectCategory = .science
    @State private var description: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Model Details")) {
                TextField("Object Name (e.g., My Puppy)", text: $objectName)
                
                Picker("Category", selection: $selectedSubject) {
                    ForEach(SubjectCategory.allCases) { category in
                        Text(appState.isLanguageEnglish ? category.englishName : category.rawValue)
                            .tag(category)
                    }
                }
            }
            
            Section(header: Text("Model Description")) {
                TextEditor(text: $description)
                    .frame(height: 100)
            }
            
            Section {
                Button(action: saveModel) {
                    HStack {
                        Spacer()
                        Text("Save to My Library")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                .listRowBackground(AppTheme.accentPrimary)
                .disabled(objectName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
        .navigationTitle("Save Object")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func saveModel() {
        let newConcept = ARConcept(
            title: objectName,
            en_title: objectName, // Could integrate translation later
            conceptDescription: description,
            en_conceptDescription: description,
            detailedDescription: "A custom 3D model scanned by the user.",
            en_detailedDescription: "A custom 3D model scanned by the user.",
            imageName: "placeholder", // Custom generated thumbnails could be Phase 3
            usdzFileName: "", // Not used since isUserGenerated
            category: selectedSubject,
            isUserGenerated: true,
            customUsdzPath: usdzPath
        )
        
        // Save to SwiftData
        modelContext.insert(newConcept)
        try? modelContext.save()
        
        onSaveCompete()
    }
}
