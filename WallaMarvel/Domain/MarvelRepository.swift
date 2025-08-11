import Foundation

protocol MarvelRepository {
    func fetchCharacters(offset: Int, limit: Int) async throws -> [CharacterModel]
}
