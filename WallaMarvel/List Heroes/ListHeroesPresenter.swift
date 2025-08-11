import Foundation

protocol ListHeroesPresenterProtocol: AnyObject {
    var ui: ListHeroesUI? { get set }
    func screenTitle() -> String
    func getHeroes()
}

protocol ListHeroesUI: AnyObject {
    func render(state: ListHeroesState)
}

enum ListHeroesState {
    case loading
    case loaded([CharacterDataModel])
    case empty
    case error(Error)
}

final class ListHeroesPresenter: ListHeroesPresenterProtocol {
    var ui: ListHeroesUI?
    private let getHeroesUseCase: GetHeroesUseCaseProtocol
    
    init(getHeroesUseCase: GetHeroesUseCaseProtocol = GetHeroes()) {
        self.getHeroesUseCase = getHeroesUseCase
    }
    
    func screenTitle() -> String {
        "List of Heroes"
    }
    
    // MARK: UseCases
    
    func getHeroes() {
        ui?.render(state: .loading)
        getHeroesUseCase.execute { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let container):
                    let heroes = container.characters
                    if heroes.isEmpty {
                        ui?.render(state: .empty)
                    } else {
                        ui?.render(state: .loaded(heroes))
                    }
                case .failure(let error):
                    ui?.render(state: .error(error))
                }
            }
        }
    }
}

