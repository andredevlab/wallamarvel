import Foundation
import CoreNetwork

final class CharacterRemoteDataSourceImpl: CharacterRemoteDataSource {
    private let characterService: CharacterService
    
    init(characterService: CharacterService) {
        self.characterService = characterService
    }
    
    func fetchAll(page: Int) async throws -> CharacterResponseDTO {
        do {
            return try await characterService.fetchCharacters(page: page)
        } catch let error as NetworkError {
            throw CharacterRemoteDataSourceImpl.handleAPIClientError(with: error)
        } catch {
            throw error
        }
    }
    
    func fetchCharacter(id: Int) async throws -> CharacterDTO {
        do {
            return try await characterService.fetchCharacter(id: id)
        } catch let error as NetworkError {
            throw CharacterRemoteDataSourceImpl.handleAPIClientError(with: error)
        } catch {
            throw error
        }
    }
    
    private static func handleAPIClientError(with error: NetworkError) -> CharacterDataSourceError {
        CharacterDataSourceError.unknown
    }
}
