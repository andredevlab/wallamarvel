import Foundation

class GetCharactersListUseCaseImpl: GetCharactersListUseCase {
    private let repository: MarvelRepository
    
    init(repository: MarvelRepository) {
        self.repository = repository
    }
    
    func execute(offset: Int, limit: Int) async throws -> [CharacterModel] {
        try await repository.fetchCharacters(offset: offset, limit: limit)
    }
}
