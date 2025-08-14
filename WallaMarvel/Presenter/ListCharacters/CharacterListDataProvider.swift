import UIKit

final class CharacterListDataProvider {
    enum Section {
        case main
    }
    
    enum Item: Hashable {
        case characterItem(id: Int)
        case listState
    }
    
    private var items: [CharacterListItemViewModel] = []
    private var lastItem = CharacterListStateViewModel(id: UUID(), state: .idle)
    
    func update(items newItems: [CharacterListItemViewModel]) {
        items.append(contentsOf: newItems)
    }
    
    func snapshot(with listState: CharacterListState) -> NSDiffableDataSourceSnapshot<Section, Item> {
        lastItem.state = listState
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items.map { .characterItem(id: $0.id) }, toSection: .main)
        snapshot.appendItems([.listState], toSection: .main)
        return snapshot
    }
    
    func visitableItem(for indexPath: IndexPath) -> (any CharacterListVisitableItem)? {
        guard indexPath.row >= 0, indexPath.row <= items.count else { return nil }
        if indexPath.row == items.count {
            return lastItem
        } else {
            return items[indexPath.row]
        }
    }
}
