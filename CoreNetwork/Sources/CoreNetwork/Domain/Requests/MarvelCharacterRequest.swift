import Foundation

enum MarvelCharacterRequest: APIRequest {
    typealias Response = CharacterResponseDTO
    
    case getCharacters(offset: Int, limit: Int)
    
    var path: String { "/v1/public/characters" }
    var method: HTTPMethod { .get }
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .getCharacters(offset, limit):
            return [
                URLQueryItem(name: "offset", value: "\(offset)"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        }
    }
}
