import Foundation

protocol CharacterLocalDataSource {
    func fetchAll(page: Int) async throws -> [CharacterModel]
    func save(page: Int, characters: [CharacterModel]) async
}
