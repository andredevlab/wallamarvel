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
    case loaded([CharacterModel])
    case empty
    case error(Error)
}

final class ListHeroesPresenter: ListHeroesPresenterProtocol {
    var ui: ListHeroesUI?
    private let getCharactersListUseCase: GetCharactersListUseCase
    
    init(getCharactersListUseCase: GetCharactersListUseCase) {
        self.getCharactersListUseCase = getCharactersListUseCase
    }
    
    func screenTitle() -> String {
        "List of Heroes"
    }
    
    // MARK: UseCases
    
    func getHeroes() {
        ui?.render(state: .loading)
        getCharactersListUseCase.execute { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let characters):
                    if characters.isEmpty {
                        ui?.render(state: .empty)
                    } else {
                        ui?.render(state: .loaded(characters))
                    }
                case .failure(let error):
                    ui?.render(state: .error(error))
                }
            }
        }
    }
}

