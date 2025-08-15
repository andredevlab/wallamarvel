import UIKit
import CoreNetwork

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: Coordinator!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        
        let characterService = CharacterServiceFactory.make()
        let characterRepository = CharacterRepositoryImpl(remoteDataSource: CharacterRemoteDataSourceImpl(characterService: characterService),
                                                          localDataSource: CharacterLocalDataSourceImpl())
        let characterListFactory = CharacterListFactory(characterRepository: characterRepository)
        let characterDetailFactory = CharacterDetailFactory(characterRepository: characterRepository)
        
        appCoordinator = CharacterListCoordinator(navigationController: navigationController,
                                                  characterListFactory: characterListFactory, 
                                                  characterDetailFactory: characterDetailFactory)
        appCoordinator.start()
        
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

