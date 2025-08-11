import Foundation

protocol GetCharactersListUseCase {
    func execute(offset: Int, limit: Int) async throws -> [CharacterModel]
}
