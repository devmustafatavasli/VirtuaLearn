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
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
                            ForEach(filteredConcepts) { concept in
                                NavigationLink(value: concept) {
                                    ConceptCardView(concept: concept)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
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
}

/// A highly polished, student-friendly card representing an educational concept.
struct ConceptCardView: View {
    let concept: ARConcept
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppTheme.color(for: concept.category).opacity(0.15))
                    .frame(width: 60, height: 60)
                Image(systemName: concept.category.iconName)
                    .font(.system(size: 30))
                    .foregroundColor(AppTheme.color(for: concept.category))
            }
            .padding(.top, 8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(concept.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(concept.conceptDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppTheme.cardBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

extension DashboardView {
    
    private func seedInitialDataIfNeeded() {
        guard concepts.isEmpty else { return }
        let sample1 = ARConcept(title: "Plant Cell", conceptDescription: "Explore the organelles of a plant cell.", usdzFileName: "plant_cell", category: .biology)
        let sample2 = ARConcept(title: "Solar System", conceptDescription: "View the planets orbiting the sun.", usdzFileName: "solar_system", category: .physics)
        
        modelContext.insert(sample1)
        modelContext.insert(sample2)
    }
}
