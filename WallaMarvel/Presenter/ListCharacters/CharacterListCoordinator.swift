import UIKit

final class CharacterListCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let characterListFactory: CharacterListFactory
    private let characterDetailFactory: CharacterDetailFactory
    
    init(navigationController: UINavigationController, 
         characterListFactory: CharacterListFactory,
         characterDetailFactory: CharacterDetailFactory) {
        self.navigationController = navigationController
        self.characterListFactory = characterListFactory
        self.characterDetailFactory = characterDetailFactory
    }
    
    func start() {
        let viewController = characterListFactory.make(delegate: self)
        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension CharacterListCoordinator: CharacterListPresenterCoordinatorDelegate {
    func showCharacterDetail(with id: Int) {
        let detailCoordinator = CharacterDetailCoordinator(navigationController: navigationController,
                                                           characterId: id,
                                                           characterDetailFactory: characterDetailFactory)
        detailCoordinator.start()
    }
}
