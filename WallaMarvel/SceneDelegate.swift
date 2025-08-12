import UIKit
import CoreNetwork

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let characterService = CharacterServiceFactory.make()
        let remoteDataSource = CharacterRemoteDataSourceImpl(characterService: characterService)
        let localDataSource = CharacterLocalDataSourceImpl()
        let characterRepository = CharacterRepositoryImpl(remoteDataSource: remoteDataSource,
                                                       localDataSource: localDataSource)
        let canLoadMoreCharactersUseCase = CanLoadMoreCharactersUseCaseImpl(repository: characterRepository)
        let getCharactersListUseCase = GetCharactersListUseCaseImpl(repository: characterRepository)
        let presenter = CharacterListPresenterImpl(getCharactersListUseCase: getCharactersListUseCase, 
                                                   canLoadMoreCharactersUseCase: canLoadMoreCharactersUseCase)
        let viewController = CharacterListViewController(presenter: presenter)
        
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

