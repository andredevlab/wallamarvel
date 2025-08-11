import Foundation

class GetCharactersListUseCaseImpl: GetCharactersListUseCase {
    private let repository: MarvelRepository
    
    init(repository: MarvelRepository) {
        self.repository = repository
    }
    
    func execute(completionBlock: @escaping (Result<[CharacterModel], Error>) -> Void) {
        repository.getHeroes(completionBlock: completionBlock)
    }
}
