import Foundation

protocol GetCharacterUseCase {
    func execute(id: Int) async throws -> CharacterModel
}
