import Foundation

final class RickAndMortyAPIClientImpl: APIClient {
    private let session: URLSession
    private let baseURL = URL(string: "https://rickandmortyapi.com")!
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func send<T: APIRequest>(_ request: T, timeInterval: TimeInterval) async throws -> T.Response {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        components?.path = request.path
        components?.queryItems = request.queryItems
        
        guard let url = components?.url else { throw NetworkError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        request.headers?.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
        urlRequest.httpBody = request.body
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            guard let http = response as? HTTPURLResponse else { throw NetworkError.badResponse }
            guard 200..<300 ~= http.statusCode else {
                let message = String(data: data, encoding: .utf8)
                throw NetworkError.server(status: http.statusCode, message: message)
            }
            return try JSONDecoder().decode(T.Response.self, from: data)
        } catch let err as DecodingError {
            throw NetworkError.decoding(err)
        } catch {
            throw NetworkError.transport(error)
        }
    }
}
