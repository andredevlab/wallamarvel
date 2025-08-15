import Foundation

final class CharacterListDidSelectCellVisitor: CharacterListItemVisitor {
    private let presenter: CharacterListPresenter
    
    init(presenter: CharacterListPresenter) {
        self.presenter = presenter
    }
    
    func visit(_ viewModel: CharacterListItemViewModel) {
        presenter.selectCharacter(id: viewModel.id)
    }
    
    func visit(_ viewModel: CharacterListStateViewModel) {
        guard viewModel.state != .loading || viewModel.state != .reachEnd else { return }
        presenter.loadCharacters()
    }
}
