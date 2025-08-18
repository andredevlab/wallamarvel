import Foundation

public struct CharacterDTO: Decodable {
    public struct PlaceDTO: Codable, Hashable {
        public let name: String
        public let url: String
    }
    
    public let id: Int
    public let name: String
    public let image: URL
    public let status: String
    public let species: String
    public let type: String
    public let gender: String
    public let origin: PlaceDTO
    public let location: PlaceDTO
    public let episode: [String]
    public let url: String
    public let created: String
}
