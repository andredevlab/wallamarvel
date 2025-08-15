import UIKit

final class CharacterListFactory {
    private let characterRepository: CharacterRepository
    
    init(characterRepository: CharacterRepository) {
        self.characterRepository = characterRepository
    }
    
    func make(delegate: CharacterListPresenterCoordinatorDelegate?) -> UIViewController {
        let presenter = CharacterListPresenterImpl(getCharactersListUseCase: GetCharactersListUseCaseImpl(repository: characterRepository),
                                                   canLoadMoreCharactersUseCase: CanLoadMoreCharactersUseCaseImpl(repository: characterRepository),
                                                   characterListDataProvider: CharacterListDataProvider())
        presenter.coordinatorDelegate = delegate
        let viewController = CharacterListViewController(presenter: presenter)
        return viewController
    }
}
