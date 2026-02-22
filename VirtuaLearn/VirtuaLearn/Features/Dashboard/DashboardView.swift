import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \ARConcept.title) private var concepts: [ARConcept]
    @State private var selectedSubject: SubjectCategory = .biology
    
    var filteredConcepts: [ARConcept] {
        concepts.filter { $0.category == selectedSubject }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Subject", selection: $selectedSubject) {
                    ForEach(SubjectCategory.allCases) { category in
                        Label(category.rawValue, systemImage: category.iconName)
                            .tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                if concepts.isEmpty {
                    ContentUnavailableView(
                        "No Data",
                        systemImage: "books.vertical",
                        description: Text("Concepts will appear here once loaded.")
                    )
                } else {
                    List(filteredConcepts) { concept in
                        NavigationLink(value: concept) {
                            HStack {
                                Image(systemName: "cube.transparent")
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading) {
                                    Text(concept.title).font(.headline)
                                    Text(concept.conceptDescription)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("VirtuaLearn")
            .navigationDestination(for: ARConcept.self) { concept in
                AROverlayView(concept: concept)
            }
            .onAppear {
                seedInitialDataIfNeeded()
            }
        }
    }
    
    private func seedInitialDataIfNeeded() {
        guard concepts.isEmpty else { return }
        let sample1 = ARConcept(title: "Plant Cell", conceptDescription: "Explore the organelles of a plant cell.", usdzFileName: "plant_cell", category: .biology)
        let sample2 = ARConcept(title: "Solar System", conceptDescription: "View the planets orbiting the sun.", usdzFileName: "solar_system", category: .physics)
        
        modelContext.insert(sample1)
        modelContext.insert(sample2)
    }
}
