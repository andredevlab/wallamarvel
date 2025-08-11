import Foundation

enum APIClientError: Error {
    case network(Error)
    case decoding(Error)
    case noData
    case unknown
}
