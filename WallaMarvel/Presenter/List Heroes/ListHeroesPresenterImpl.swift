import Foundation
import Combine

protocol ListHeroesPresenter: AnyObject {
    var statePublisher: AnyPublisher<ListHeroesState, Never> { get }
    
    func screenTitle() -> String
    func getHeroes()
}

final class ListHeroesPresenterImpl: ListHeroesPresenter {
    
    // MARK: Private Properties
    
    @Published private var state: ListHeroesState = .idle
    private let getCharactersListUseCase: GetCharactersListUseCase
    private var characterListDataProvider = CharacterListDataProvider()
    private var isLoading = false
    
    // MARK: Internal Properties
    
    var statePublisher: AnyPublisher<ListHeroesState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    // MARK: Initialization
    
    init(getCharactersListUseCase: GetCharactersListUseCase) {
        self.getCharactersListUseCase = getCharactersListUseCase
    }
    
    // MARK: Internal Methods
    
    func screenTitle() -> String {
        "List of Heroes"
    }
    
    func getHeroes() {
        guard !isLoading else { return }
        isLoading = true
        state = .loading
        
        Task {
            do {
                let characters = try await getCharactersListUseCase.execute(offset: 0, limit: 20)
                if characters.isEmpty {
                    state = .empty
                } else {
                    characterListDataProvider.update(items: characters.map { CharacterViewModel(model: $0) })
                    state = .loaded(dataProvider: characterListDataProvider)
                }
            } catch {
                state = .error(error)
            }
        }
    }
}

