import Foundation

protocol CharacterRepository {
    func hasMoreCharactersToLoad() -> Bool
    func fetchCharacters() async throws -> [CharacterModel]
}
