import Foundation

struct CharacterModel: Codable {
    let id: Int
    let name: String
    let image: URL
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: LocationModel
    let location: LocationModel
    let episode: [URL]
    let url: String
    let created: String
}
