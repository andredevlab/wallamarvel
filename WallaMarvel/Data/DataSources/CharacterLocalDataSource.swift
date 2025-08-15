import Foundation

protocol CharacterLocalDataSource {
    func fetchAll(page: Int) async throws -> [CharacterModel]
    func fetch(id: Int) async throws -> CharacterModel
    
    func save(page: Int, characters: [CharacterModel]) async
    func save(character: CharacterModel) async
}
