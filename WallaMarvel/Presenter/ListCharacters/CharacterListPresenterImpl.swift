import Foundation
import Combine

protocol CharacterListPresenterCoordinatorDelegate: AnyObject {
    func showCharacterDetail(with id: Int)
}

protocol CharacterListPresenter: AnyObject {
    var statePublisher: AnyPublisher<(CharacterListState, CharacterListDataProvider), Never> { get }
    
    func screenTitle() -> String
    func loadCharacters()
    func selectCharacter(id: Int)
}

final class CharacterListPresenterImpl: CharacterListPresenter {
    
    // MARK: Private Properties
    
    @Published private var listState: CharacterListState = .loading
    
    private let getCharactersListUseCase: GetCharactersListUseCase
    private let canLoadMoreCharactersUseCase: CanLoadMoreCharactersUseCase
    private let characterListDataProvider: CharacterListDataProvider
    
    // MARK: Internal Properties
    
    weak var coordinatorDelegate: CharacterListPresenterCoordinatorDelegate?
    
    var statePublisher: AnyPublisher<(CharacterListState, CharacterListDataProvider), Never> {
        $listState
            .map { [unowned self] in ($0, self.characterListDataProvider) }
            .eraseToAnyPublisher()
    }
    
    // MARK: Initialization
    
    init(getCharactersListUseCase: GetCharactersListUseCase, 
         canLoadMoreCharactersUseCase: CanLoadMoreCharactersUseCase,
         characterListDataProvider: CharacterListDataProvider) {
        self.getCharactersListUseCase = getCharactersListUseCase
        self.canLoadMoreCharactersUseCase = canLoadMoreCharactersUseCase
        self.characterListDataProvider = characterListDataProvider
    }
    
    // MARK: Internal Methods
    
    func screenTitle() -> String {
        // TODO: - L10n
        "List of Characters"
    }
    
    func loadCharacters() {
        listState = .loading
        
        Task {
            do {
                let characters = try await getCharactersListUseCase.execute()
                characterListDataProvider.update(items: characters.map { CharacterListItemViewModel(model: $0) })
                listState = canLoadMoreCharactersUseCase.execute() ? .loadMore : .reachEnd
            } catch {
                listState = canLoadMoreCharactersUseCase.execute() ? .error : .reachEnd
            }
        }
    }
    
    func selectCharacter(id: Int) {
        coordinatorDelegate?.showCharacterDetail(with: id)
    }
}

