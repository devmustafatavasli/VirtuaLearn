import SwiftUI
import SwiftData
import RealityKit

struct DashboardView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \ARConcept.title) private var concepts: [ARConcept]
    @State private var selectedSubject: SubjectCategory = .science
    @State private var isShowingCaptureSession = false
    
    var filteredConcepts: [ARConcept] {
        concepts.filter { $0.category == selectedSubject }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Subject", selection: $selectedSubject) {
                    ForEach(SubjectCategory.allCases) { category in
                        Label(
                            appState.isLanguageEnglish ? category.englishName : category.rawValue, 
                            systemImage: category.iconName
                        )
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 16) {
                        #if os(iOS) && !targetEnvironment(simulator)
                        if ObjectCaptureSession.isSupported {
                            Button(action: {
                                isShowingCaptureSession = true
                            }) {
                                Image(systemName: "plus")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(AppTheme.accentPrimary)
                                    .foregroundColor(.white)
                                    .clipShape(Capsule())
                            }
                        }
                        #endif
                        
                        Button(action: {
                            withAnimation {
                                appState.isLanguageEnglish.toggle()
                            }
                        }) {
                            Text(appState.isLanguageEnglish ? "🇹🇷 TR" : "🇬🇧 EN")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(AppTheme.cardBackground)
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            .sheet(isPresented: $isShowingCaptureSession) {
                CaptureSessionView()
            }
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
    @Environment(AppState.self) private var appState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // New 2D Visual Image Support
            if let uiImage = UIImage(named: concept.imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(12)
            } else {
                // Fallback to the old Icon UI if image isn't in Asset Catalog
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppTheme.color(for: concept.category).opacity(0.15))
                        .frame(height: 120)
                    Image(systemName: concept.category.iconName)
                        .font(.system(size: 40))
                        .foregroundColor(AppTheme.color(for: concept.category))
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(appState.isLanguageEnglish ? concept.en_title : concept.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(appState.isLanguageEnglish ? concept.en_conceptDescription : concept.conceptDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 8)
        }
        .padding(8)
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
        
        // Define a local struct to decode JSON safely before inserting into SwiftData
        struct HotspotDTO: Codable {
            let id: String
            let title: String
            let en_title: String
            let description: String
            let en_description: String
            let x: Float
            let y: Float
            let z: Float
        }
        
        struct ConceptDTO: Codable {
            let id: String
            let title: String
            let en_title: String?
            let conceptDescription: String
            let en_conceptDescription: String?
            let detailedDescription: String
            let en_detailedDescription: String?
            let imageName: String
            let usdzFileName: String
            let categoryRawValue: String
            let isFavorite: Bool
            let hotspots: [HotspotDTO]?
        }
        
        // Try to load from the JSON file in the bundle
        if let url = Bundle.main.url(forResource: "meb_curriculum_data", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decodedConcepts = try? JSONDecoder().decode([ConceptDTO].self, from: data) {
            
            for dto in decodedConcepts {
                let category = SubjectCategory(rawValue: dto.categoryRawValue) ?? .science
                
                // Map the decoded DTO hotspots to the data model hotspots
                let mappedHotspots = dto.hotspots?.map { hDTO in
                    Hotspot(
                        id: hDTO.id,
                        title: hDTO.title,
                        en_title: hDTO.en_title,
                        description: hDTO.description,
                        en_description: hDTO.en_description,
                        x: hDTO.x,
                        y: hDTO.y,
                        z: hDTO.z
                    )
                } ?? []
                
                let concept = ARConcept(
                    id: UUID(uuidString: dto.id) ?? UUID(),
                    title: dto.title,
                    en_title: dto.en_title ?? dto.title,
                    conceptDescription: dto.conceptDescription,
                    en_conceptDescription: dto.en_conceptDescription ?? dto.conceptDescription,
                    detailedDescription: dto.detailedDescription,
                    en_detailedDescription: dto.en_detailedDescription ?? dto.detailedDescription,
                    imageName: dto.imageName,
                    usdzFileName: dto.usdzFileName,
                    category: category,
                    isFavorite: dto.isFavorite,
                    hotspots: mappedHotspots
                )
                modelContext.insert(concept)
            }
            print("Successfully loaded \(decodedConcepts.count) concepts from MEB JSON.")
            
        } else {
            print("WARNING: meb_curriculum_data.json not found in Bundle.")
        }
    }
}
