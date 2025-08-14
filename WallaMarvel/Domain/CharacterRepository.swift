import Foundation

protocol CharacterRepository {
    func hasMoreCharactersToLoad() -> Bool
    func fetchCharacters() async throws -> [CharacterModel]
    func fetchCharacter(id: Int) async throws -> CharacterModel
}
