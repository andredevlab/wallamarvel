import Foundation

class GetCharactersListUseCaseImpl: GetCharactersListUseCase {
    private let repository: CharacterRepository
    
    init(repository: CharacterRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [CharacterModel] {
        try await repository.fetchCharacters()
    }
}
