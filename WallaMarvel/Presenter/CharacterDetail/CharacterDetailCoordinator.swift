import SwiftUI

final class CharacterDetailCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let characterDetailFactory: CharacterDetailFactory
    private let characterId: Int
    
    init(navigationController: UINavigationController,
         characterId: Int,
         characterDetailFactory: CharacterDetailFactory) {
        self.navigationController = navigationController
        self.characterDetailFactory = characterDetailFactory
        self.characterId = characterId
    }
    
    func start() {
        let viewController = characterDetailFactory.make(id: characterId)
        navigationController.pushViewController(viewController, animated: true)
    }
}
