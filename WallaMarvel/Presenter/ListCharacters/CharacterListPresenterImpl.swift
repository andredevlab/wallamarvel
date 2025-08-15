import Foundation
import Combine

protocol CharacterListPresenterCoordinatorDelegate: AnyObject {
    func showCharacterDetail(with id: Int)
}

protocol CharacterListPresenter: AnyObject {
    var statePublisher: AnyPublisher<CharacterListState, Never> { get }
    
    func screenTitle() -> String
    func loadCharacters()
    func loadCharacters(with: CharacterListFilter)
    func selectCharacter(id: Int)
}

enum CharacterListFilter: Equatable {
    case none
    case name(String)
}

final class CharacterListPresenterImpl: CharacterListPresenter {
    
    // MARK: Private Properties
    
    private let getCharactersListUseCase: GetCharactersListUseCase
    private let canLoadMoreCharactersUseCase: CanLoadMoreCharactersUseCase
    private let characterListDataProvider: CharacterListDataProvider
    
    @Published private var listState: CharacterListState = .loadingMore
    private let filterSubject = CurrentValueSubject<CharacterListFilter, Never>(.none)
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Internal Properties
    
    weak var coordinatorDelegate: CharacterListPresenterCoordinatorDelegate?
    
    var statePublisher: AnyPublisher<CharacterListState, Never> {
        $listState.eraseToAnyPublisher()
    }
    
    // MARK: Initialization
    
    init(getCharactersListUseCase: GetCharactersListUseCase, 
         canLoadMoreCharactersUseCase: CanLoadMoreCharactersUseCase,
         characterListDataProvider: CharacterListDataProvider) {
        self.getCharactersListUseCase = getCharactersListUseCase
        self.canLoadMoreCharactersUseCase = canLoadMoreCharactersUseCase
        self.characterListDataProvider = characterListDataProvider
        
        setupSubscribers()
    }
    
    // MARK: Private Methods
    
    private func setupSubscribers() {
        // Using a filterSubject to debounce the inputs and save processing resources
        filterSubject
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink(receiveValue: {  [weak self] filter in
                guard let self else { return }
                
                characterListDataProvider.apply(filter: filter)
                listState = filter == .none ? .loadMore : .reachEnd
            })
            .store(in: &cancellables)
    }
    
    // MARK: Internal Methods
    
    func screenTitle() -> String {
        // TODO: - L10n
        "List of Characters"
    }
    
    func loadCharacters() {
        listState = .loadingMore
        
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
    
    func loadCharacters(with filter: CharacterListFilter) {
        listState = .loadingFilter
        filterSubject.send(filter)
    }
}

