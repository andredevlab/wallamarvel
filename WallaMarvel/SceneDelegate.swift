import UIKit
import CoreNetwork

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let characterService = CharacterServiceFactory.make()
        let characterRepository = CharacterRepositoryImpl(remoteDataSource: CharacterRemoteDataSourceImpl(characterService: characterService),
                                                       localDataSource: CharacterLocalDataSourceImpl())
        
        let presenter = CharacterListPresenterImpl(getCharactersListUseCase: GetCharactersListUseCaseImpl(repository: characterRepository),
                                                   canLoadMoreCharactersUseCase: CanLoadMoreCharactersUseCaseImpl(repository: characterRepository),
                                                   characterListDataProvider: CharacterListDataProvider())
        
        let viewController = CharacterListViewController(presenter: presenter)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

