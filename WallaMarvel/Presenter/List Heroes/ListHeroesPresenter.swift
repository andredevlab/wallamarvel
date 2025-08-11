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
        Task {
            do {
                let characters = try await getCharactersListUseCase.execute(offset: 0, limit: 20)
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    if characters.isEmpty {
                        ui?.render(state: .empty)
                    } else {
                        ui?.render(state: .loaded(characters))
                    }
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    ui?.render(state: .error(error))
                }
            }
        }
    }
}

