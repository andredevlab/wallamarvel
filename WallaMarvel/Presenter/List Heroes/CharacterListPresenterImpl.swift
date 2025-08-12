import Foundation
import Combine

protocol CharacterListPresenter: AnyObject {
    var statePublisher: AnyPublisher<(CharacterListDataProvider.ListState, CharacterListDataProvider), Never> { get }
    
    func screenTitle() -> String
    func loadCharacters()
}

final class CharacterListPresenterImpl: CharacterListPresenter {
    
    // MARK: Private Properties
    
    @Published private var listState: CharacterListDataProvider.ListState = .loading
    
    private let getCharactersListUseCase: GetCharactersListUseCase
    private let canLoadMoreCharactersUseCase: CanLoadMoreCharactersUseCase
    private var characterListDataProvider = CharacterListDataProvider()
    private var isLoading = false
    
    // MARK: Internal Properties
    
    var statePublisher: AnyPublisher<(CharacterListDataProvider.ListState, CharacterListDataProvider), Never> {
        $listState
            .map { [unowned self] in ($0, self.characterListDataProvider) }
            .eraseToAnyPublisher()
    }
    
    // MARK: Initialization
    
    init(getCharactersListUseCase: GetCharactersListUseCase, canLoadMoreCharactersUseCase: CanLoadMoreCharactersUseCase) {
        self.getCharactersListUseCase = getCharactersListUseCase
        self.canLoadMoreCharactersUseCase = canLoadMoreCharactersUseCase
    }
    
    // MARK: Internal Methods
    
    func screenTitle() -> String {
        // TODO: - L10n
        "List of Heroes"
    }
    
    func loadCharacters() {
        guard !isLoading else { return }
        isLoading = true
        listState = .loading
        
        Task {
            do {
                let characters = try await getCharactersListUseCase.execute()
                characterListDataProvider.update(items: characters.map { CharacterViewModel(model: $0) })
                listState = canLoadMoreCharactersUseCase.execute() ? .loadMore : .reachEnd
                isLoading = false
            } catch {
                listState = canLoadMoreCharactersUseCase.execute() ? .error : .reachEnd
                isLoading = false
            }
        }
    }
}

