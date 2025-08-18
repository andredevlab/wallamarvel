import Foundation

public enum NetworkError: Error {
    case invalidURL
    case transport(Error)
    case badResponse
    case server(status: Int, message: String?)
    case decoding(Error)
}
