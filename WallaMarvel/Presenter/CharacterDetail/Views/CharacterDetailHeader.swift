import SwiftUI
import Kingfisher

struct CharacterDetailHeader: View {
    private let minHeight: CGFloat = 260
    private let maxHeight: CGFloat = 360
    
    @State private var didFailToLoadImage = false
    
    let image: URL
    let species: String
    let type: String
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // This group is to show either the Image or the Error view
            Group {
                if didFailToLoadImage {
                    Color.gray.opacity(0.12)
                        .overlay(
                            Text("Image not available")
                                .font(.caption2.weight(.regular))
                        )
                } else {
                    KFImage(image)
                        .placeholder {
                            ProgressView()
                                .frame(maxWidth: .infinity, minHeight: 260)
                        }
                        .onFailure { _ in
                            didFailToLoadImage = true
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, minHeight: 260, maxHeight: 360)
                        .clipped()
                }
            }
            .frame(maxWidth: .infinity,
                   minHeight: minHeight,
                   maxHeight: maxHeight)
            .clipped()
            
            // The Gradient above the Image/Error view
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.35)]),
                startPoint: .center,
                endPoint: .bottom
            )
            .frame(maxWidth: .infinity,
                   minHeight: minHeight,
                   maxHeight: maxHeight)
            .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
            .allowsHitTesting(false)
            
            // The tags for specie and type - Above the Gradient
            VStack(alignment: .leading, spacing: 6) {
                Tag(text: species)
                if !type.isEmpty {
                    Tag(text: type)
                }
            }
            .padding(12)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
}

#if DEBUG
struct CharacterDetailHeader_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Content - Light
            NavigationView {
                CharacterDetailHeader(image: URL(string: "https://rickandmortyapi.com")!,
                                      species: "foo.species",
                                      type: "foo.type")
            }
            .previewDisplayName("Content - Light")
            
            // Content - Dark
            NavigationView {
                CharacterDetailHeader(image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!,
                                      species: "foo.species",
                                      type: "foo.type")
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Content - Dark")
        }
    }
}
#endif
