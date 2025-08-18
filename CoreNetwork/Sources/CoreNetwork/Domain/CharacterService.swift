import Foundation

public protocol CharacterService {
    func fetchCharacters(page: Int) async throws -> CharacterResponseDTO
    func fetchCharacter(id: Int) async throws -> CharacterDTO
}
