import CryptoKit
import Foundation

final class MarvelAPIClientImpl: APIClient {
    private let session: URLSession
    private let publicKey: String
    private let privateKey: String
    private let baseURL = URL(string: "https://gateway.marvel.com")!
    
    // TODO(Security): Hardcoded API keys in the client are inherently vulnerable (reverse engineering, proxying, memory dumps).
    // We cannot fully protect secrets on mobile. Prefer handling keys/signing on a secure backend and issue short-lived, scoped tokens to the app.
    // Given this is a test/prototype app, the trade-off is acceptable here.
    init(session: URLSession = .shared,
         publicKey: String = "704a79d60703866a87aac0f4a31c4eed",
         privateKey: String = "39d779808c545a4e57beb086dd1d35d01b48f9c4") {
        self.session = session
        self.publicKey = publicKey
        self.privateKey = privateKey
    }
    
    func send<T: APIRequest>(_ request: T, timeInterval: TimeInterval) async throws -> T.Response {
        let ts = Int(timeInterval)
        let digest = Insecure.MD5.hash(data: Data("\(ts)\(privateKey)\(publicKey)".utf8))
        let hash = digest.map { String(format: "%02hhx", $0) }.joined()
        
        var items = request.queryItems ?? []
        items.append(contentsOf: [
            URLQueryItem(name: "ts", value: "\(ts)"),
            URLQueryItem(name: "apikey", value: publicKey),
            URLQueryItem(name: "hash", value: hash)
        ])
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.path = request.path
        components?.queryItems = items
        
        guard let url = components?.url else { throw NetworkError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        request.headers?.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        urlRequest.httpBody = request.body
        
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw NetworkError.transport(error)
        }
        
        guard let http = response as? HTTPURLResponse else { throw NetworkError.badResponse }
        
        guard 200..<300 ~= http.statusCode else {
            let message = String(data: data, encoding: .utf8)
            throw NetworkError.server(status: http.statusCode, message: message)
        }
        
        do {
            return try JSONDecoder().decode(T.Response.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}
