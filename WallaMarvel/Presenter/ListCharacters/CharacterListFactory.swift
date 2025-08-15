import UIKit

final class CharacterListFactory {
    private let characterRepository: CharacterRepository
    
    init(characterRepository: CharacterRepository) {
        self.characterRepository = characterRepository
    }
    
    func make(delegate: CharacterListPresenterCoordinatorDelegate?) -> UIViewController {
        let characterListDataProvider = CharacterListDataProvider()
        let presenter = CharacterListPresenterImpl(getCharactersListUseCase: GetCharactersListUseCaseImpl(repository: characterRepository),
                                                   canLoadMoreCharactersUseCase: CanLoadMoreCharactersUseCaseImpl(repository: characterRepository),
                                                   characterListDataProvider: characterListDataProvider)
        presenter.coordinatorDelegate = delegate
        let viewController = CharacterListViewController(presenter: presenter, 
                                                         characterListDataProvider: characterListDataProvider)
        return viewController
    }
}
