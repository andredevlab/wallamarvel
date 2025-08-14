import Foundation

final class CharacterListDidSelectCellVisitor: CharacterListItemVisitor {
    private let presenter: CharacterListPresenter
    
    init(presenter: CharacterListPresenter) {
        self.presenter = presenter
    }
    
    func visit(_ viewModel: CharacterListItemViewModel) {
        // TODO: - Redirect to Detail
    }
    
    func visit(_ viewModel: CharacterListStateViewModel) {
        guard viewModel.state == .loadMore else { return }
        presenter.loadCharacters()
    }
}
