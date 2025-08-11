import UIKit

final class ListHeroesViewController: UIViewController {
    var mainView: ListHeroesView { return view as! ListHeroesView  }
    
    var presenter: ListHeroesPresenterProtocol?
    var listHeroesProvider: ListHeroesAdapter?
    
    override func loadView() {
        view = ListHeroesView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        listHeroesProvider = ListHeroesAdapter(tableView: mainView.heroesTableView)
        presenter?.getHeroes()
        presenter?.ui = self
        
        title = presenter?.screenTitle()
        
        // TODO: Refactor to avoid direct element access; expose component interactions through delegates instead.
        mainView.heroesTableView.delegate = self
        mainView.retryButton.addTarget(self, action: #selector(retryTapped), for: .touchUpInside)
        presenter?.getHeroes()
    }
    
    @objc private func retryTapped() {
        presenter?.getHeroes()
    }
}

extension ListHeroesViewController: ListHeroesUI {
    func render(state: ListHeroesState) {
        switch state {
        case .loading:
            mainView.update(state: .loading)
        case .loaded(let heroes):
            listHeroesProvider?.heroes = heroes
            mainView.update(state: .content)
        case .empty:
            mainView.update(state: .empty)
        case .error(let error):
            mainView.update(state: .error(message: error.localizedDescription))
        }
    }
}

extension ListHeroesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let presenter = ListHeroesPresenter()
        let listHeroesViewController = ListHeroesViewController()
        listHeroesViewController.presenter = presenter
        
        navigationController?.pushViewController(listHeroesViewController, animated: true)
    }
}

