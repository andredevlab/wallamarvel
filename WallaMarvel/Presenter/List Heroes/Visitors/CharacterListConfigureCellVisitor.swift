import UIKit

final class CharacterListConfigureCellVisitor: CharacterListItemVisitor {
    private let tableView: UITableView
    private let indexPath: IndexPath
    private(set) var cell: UITableViewCell!
    
    init(tableView: UITableView, indexPath: IndexPath) {
        self.tableView = tableView
        self.indexPath = indexPath
    }
    
    func visit(_ viewModel: CharacterListItemViewModel) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterItemViewCell",
                                                       for: indexPath) as? CharacterItemViewCell else { return }
        cell.configure(viewModel: viewModel)
        self.cell = cell
    }
    
    func visit(_ viewModel: CharacterListStateViewModel) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListStateViewCell",
                                                       for: indexPath) as? ListStateViewCell else { return }
        cell.configure(viewModel: viewModel)
        
        self.cell = cell
    }
}
