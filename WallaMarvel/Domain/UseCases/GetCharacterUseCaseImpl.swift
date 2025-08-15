import Foundation

final class GetCharacterUseCaseImpl: GetCharacterUseCase {
    private let repository: CharacterRepository
    
    init(repository: CharacterRepository) {
        self.repository = repository
    }
    
    func execute(id: Int) async throws -> CharacterModel {
        try await repository.fetchCharacter(id: id)
    }
}
