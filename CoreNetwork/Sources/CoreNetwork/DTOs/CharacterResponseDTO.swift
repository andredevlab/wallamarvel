import Foundation

public struct CharacterResponseDTO: Decodable {
    public let info: InfoDTO
    public let results: [CharacterDTO]
    
    public struct InfoDTO: Decodable {
        public let count: Int
        public let pages: Int
        public let next: String?
        public let prev: String?
    }
}
