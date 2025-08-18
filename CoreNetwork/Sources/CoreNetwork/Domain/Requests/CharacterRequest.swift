import Foundation

enum CharacterRequest<T: Decodable>: APIRequest {
    typealias Response = T
    
    case list(page: Int)
    case detail(id: Int)
    
    var method: HTTPMethod { .get }
    var queryItems: [URLQueryItem]? {
        switch self {
        case .list(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .detail:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .list:
            return "/api/character"
        case .detail(let id):
            return "/api/character/\(id)"
        }
    }
}
