import SwiftUI
import Combine
import Kingfisher

struct CharacterDetailView<T: CharacterDetailPresenter>: View {
    @ObservedObject var presenter: T
    
    private let characterId: Int
    
    init(presenter: T, characterId: Int) {
        self.characterId = characterId
        self.presenter = presenter
    }
    
    var body: some View {
        content
            .task { await presenter.loadCharacter(with: characterId) }
    }
    
    @ViewBuilder
    private var content: some View {
        switch presenter.state {
        case .idle, .loading:
            loadingView
            
        case .failure(let message):
            errorView(message: message)
            
        case .success(let character):
            successView(character)
        }
    }
    
    // MARK: - Subviews
    
    private var loadingView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.yellow)
            Text(message).foregroundColor(.secondary)
            Button {
                Task { await presenter.loadCharacter(with: characterId) }
            } label: {
                Label("Retry", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func successView(_ character: CharacterModel) -> some View {
        ScrollView {
            // Photo with Tags
            CharacterDetailHeader(image: character.image,
                                  species: character.species,
                                  type: character.type)
            
            VStack(spacing: 16) {
                // Name
                VStack(spacing: 8) {
                    Text(character.name)
                        .font(.system(.largeTitle, design: .rounded).weight(.bold))
                        .multilineTextAlignment(.center)
                        .accessibilityAddTraits(.isHeader)
                    StatusBadge(status: character.status)
                }
                .padding(.top, 8)
                
                // Facts
                Card {
                    LazyVGrid(columns: [GridItem(.flexible(minimum: 80)),
                                        GridItem(.flexible(minimum: 80))],
                              spacing: 12) {
                        FactRow(title: "Species", value: character.species)
                        FactRow(title: "Type", value: character.type.isEmpty ? "—" : character.type)
                        FactRow(title: "Gender", value: character.gender)
                        FactRow(title: "Is Alive?", value: character.status)
                    }
                }
                
                // Places
                Card(spacing: 12) {
                    SectionHeader(title: "Places")
                    MapRowLink(title: "Origin", subtitle: character.origin.name) {
                        if let url = character.origin.url { 
                            
                        }
                    }
                    Divider()
                    MapRowLink(title: "Current Location", subtitle: character.location.name) {
                        if let url = character.location.url {
                            
                        }
                    }
                }
                
                // Episodes
                if !character.episode.isEmpty {
                    Card(spacing: 12) {
                        SectionHeader(title: "Episodes")
                        VStack(spacing: 8) {
                            ForEach(character.episode, id: \.self) { epURL in
                                let epID = epURL.lastPathComponent
                                HStack(spacing: 12) {
                                    Image(systemName: "play.circle")
                                    Text("Episode \(epID)")
                                        .font(.body.weight(.medium))
                                    Spacer()
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "arrow.up.right.square")
                                            .imageScale(.medium)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(Color(UIColor.secondarySystemBackground).opacity(0.9))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                                )
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#if DEBUG
import SwiftUI
import Combine
// Se o protocolo estiver anotado com @MainActor e loadCharacter async:
final class CharacterDetailPresenterMock: ObservableObject, CharacterDetailPresenter {
    @Published private(set) var state: CharacterDetailState
    
    init(state: CharacterDetailState) {
        self.state = state
    }
    
    func loadCharacter(with id: Int) async {
        // no-op
    }
}

struct CharacterDetailView_Previews: PreviewProvider {
    
    static let sample = CharacterModel(
        id: 1,
        name: "Rick Sanchez",
        image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!, // <- corrige .jpeg
        status: "Alive",
        species: "Human",
        type: "",
        gender: "Male",
        origin: .init(name: "Earth (C-137)", url: URL(string: "https://rickandmortyapi.com/api/location/1")),
        location: .init(name: "Citadel of Ricks", url: URL(string: "https://rickandmortyapi.com/api/location/3")),
        episode: [
            URL(string: "https://rickandmortyapi.com/api/episode/1")!,
            URL(string: "https://rickandmortyapi.com/api/episode/2")!
        ],
        url: "https://rickandmortyapi.com/api/character/1",
        created: ""
    )
    
    static var previews: some View {
        Group {
            // Success - Light
            NavigationView {
                CharacterDetailView(
                    presenter: CharacterDetailPresenterMock(state: .success(sample)),
                    characterId: 1
                )
            }
            .previewDisplayName("Content - Light")
            .previewDevice("iPhone 14")
            
            // Failure - Dark
            NavigationView {
                CharacterDetailView(
                    presenter: CharacterDetailPresenterMock(state: .failure(message: "foo.error.message")),
                    characterId: 1
                )
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Content - Dark")
            .previewDevice("iPhone 14")
            
            // Loading
            NavigationView {
                CharacterDetailView(
                    presenter: CharacterDetailPresenterMock(state: .loading),
                    characterId: 1
                )
            }
            .previewDisplayName("Loading")
            .previewDevice("iPhone 14")
        }
    }
}
#endif
