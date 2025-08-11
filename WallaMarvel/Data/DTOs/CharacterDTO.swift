import Foundation

struct CharacterDTO: Decodable {
    let id: Int
    let name: String
    let thumbnail: ThumbnailDTO
}
