import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let apiClient = APIClientImpl()
        let marvelRemoteDataSource = MarvelRemoteDataSourceImpl(apiClient: apiClient)
        let marvelRepository = MarvelRepositoryImpl(dataSource: marvelRemoteDataSource)
        let getCharactersListUseCase = GetCharactersListUseCaseImpl(repository: marvelRepository)
        let presenter = ListHeroesPresenter(getCharactersListUseCase: getCharactersListUseCase)
        let listHeroesViewController = ListHeroesViewController()
        listHeroesViewController.presenter = presenter
        
        let navigationController = UINavigationController(rootViewController: listHeroesViewController)
        window.rootViewController = navigationController
        self.window = window
        self.window?.makeKeyAndVisible()
    }
}

