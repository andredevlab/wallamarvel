import Foundation
import CoreNetwork

final class MarvelRemoteDataSourceImpl: MarvelRemoteDataSource {
    private let characterService: CharacterService
    
    init(characterService: CharacterService) {
        self.characterService = characterService
    }
    
    func fetchCharacters(offset: Int, limit: Int) async throws -> [CharacterDTO] {
        do {
            let response = try await characterService.fetchCharacters(offset: offset, limit: limit)
            return response.data.results
        } catch let error as NetworkError {
            throw MarvelRemoteDataSourceImpl.handleAPIClientError(with: error)
        } catch {
            throw error
        }
    }
    
    private static func handleAPIClientError(with error: NetworkError) -> MarvelDataSourceError {
        MarvelDataSourceError.unknown
    }
}
