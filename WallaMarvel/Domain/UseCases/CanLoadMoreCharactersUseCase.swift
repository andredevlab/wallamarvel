import Foundation

protocol CanLoadMoreCharactersUseCase {
    func execute() -> Bool
}

final class CanLoadMoreCharactersUseCaseImpl: CanLoadMoreCharactersUseCase {
    private let repository: CharacterRepository
    
    init(repository: CharacterRepository) {
        self.repository = repository
    }
    
    func execute() -> Bool {
        repository.hasMoreCharactersToLoad()
    }
}
