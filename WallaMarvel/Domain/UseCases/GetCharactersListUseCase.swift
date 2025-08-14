import Foundation

protocol GetCharactersListUseCase {
    func execute() async throws -> [CharacterModel]
}
