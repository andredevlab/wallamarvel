import Foundation

protocol MarvelDataSourceProtocol {
    func getHeroes(completionBlock: @escaping (Result<CharacterDataContainer, Error>) -> Void)
}

enum MarvelDataSourceError: LocalizedError {
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "An unknown error occurred. Please try again."
        }
    }
}

final class MarvelDataSource: MarvelDataSourceProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    func getHeroes(completionBlock: @escaping (Result<CharacterDataContainer, Error>) -> Void) {
        apiClient.getHeroes { result in
            guard case let .failure(error) = result else {
                completionBlock(result)
                return
            }
            
            guard let error = error as? APIClientError else {
                completionBlock(.failure(error))
                return
            }
            
            completionBlock(.failure(MarvelDataSource.handleAPIClientError(with: error)))
        }
    }
    
    private static func handleAPIClientError(with error: APIClientError) -> MarvelDataSourceError {
        MarvelDataSourceError.unknown
    }
}
