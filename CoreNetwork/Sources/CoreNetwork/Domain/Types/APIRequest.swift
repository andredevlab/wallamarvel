import Foundation

protocol APIRequest {
    associatedtype Response: Decodable
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

extension APIRequest {
    var queryItems: [URLQueryItem]? { nil }
    var headers: [String: String]? { nil }
    var body: Data? { nil }
}
