import Foundation

protocol APIClientProtocol {
    func getHeroes(completionBlock: @escaping (Result<CharacterDataContainer, Error>) -> Void)
}

enum APIClientError: Error {
    case network(Error)
    case decoding(Error)
    case noData
    case unknown
}

final class APIClient: APIClientProtocol {
    enum Constant {
        static let privateKey = "188f9a5aa76846d907c41cbea6506e4cc455293f"
        static let publicKey = "d575c26d5c746f623518e753921ac847"
    }
    
    init() { }
    
    func getHeroes(completionBlock: @escaping (Result<CharacterDataContainer, Error>) -> Void) {
        let ts = String(Int(Date().timeIntervalSince1970))
        let privateKey = Constant.privateKey
        let publicKey = Constant.publicKey
        let hash = "\(ts)\(privateKey)\(publicKey)".md5
        let parameters: [String: String] = ["apikey": publicKey,
                                            "ts": ts,
                                            "hash": hash]
        
        let endpoint = "https://gateway.marvel.com:443/v1/public/characters"
        var urlComponent = URLComponents(string: endpoint)
        urlComponent?.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        let urlRequest = URLRequest(url: urlComponent!.url!)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completionBlock(.failure(APIClientError.network(error!)))
                return
            }
            
            guard let data else {
                completionBlock(.failure(APIClientError.noData))
                return
            }
            
            do {
                let dataModel = try JSONDecoder().decode(CharacterDataContainer.self, from: data)
                completionBlock(.success(dataModel))
            } catch {
                completionBlock(.failure(APIClientError.decoding(error)))
            }
        }.resume()
    }
}
