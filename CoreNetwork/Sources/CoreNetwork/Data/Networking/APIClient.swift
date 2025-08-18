import Foundation

protocol APIClient {
    func send<T: APIRequest>(_ request: T, timeInterval: TimeInterval) async throws -> T.Response
}
