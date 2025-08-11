import Foundation

final class MarvelRemoteDataSourceImpl: MarvelRemoteDataSource {
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getHeroes(completionBlock: @escaping (Result<CharacterContainerDTO, Error>) -> Void) {
        apiClient.getHeroes { result in
            guard case let .failure(error) = result else {
                completionBlock(result)
                return
            }
            
            guard let error = error as? APIClientError else {
                completionBlock(.failure(error))
                return
            }
            
            completionBlock(.failure(MarvelRemoteDataSourceImpl.handleAPIClientError(with: error)))
        }
    }
    
    private static func handleAPIClientError(with error: APIClientError) -> MarvelDataSourceError {
        MarvelDataSourceError.unknown
    }
}
