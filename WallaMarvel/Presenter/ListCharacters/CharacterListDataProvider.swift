import UIKit

final class CharacterListDataProvider {
    enum Section {
        case main
    }
    
    enum Item: Hashable {
        case characterItem(id: Int)
        case listState(state: CharacterListState)
    }
    
    private var items: [CharacterListItemViewModel] = []
    private var lastItemState: CharacterListState?
    
    func update(items newItems: [CharacterListItemViewModel]) {
        items.append(contentsOf: newItems)
    }
    
    func snapshot(with listState: CharacterListState) -> NSDiffableDataSourceSnapshot<Section, Item> {
        lastItemState = listState
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items.map { .characterItem(id: $0.id) }, toSection: .main)
        snapshot.appendItems([.listState(state: listState)], toSection: .main)
        return snapshot
    }
    
    func visitableItem(for indexPath: IndexPath) -> (any CharacterListVisitableItem)? {
        guard indexPath.row >= 0, indexPath.row <= items.count else { return nil }
        if indexPath.row == items.count {
            return CharacterListStateViewModel(id: UUID(), state: lastItemState ?? .idle)
        } else {
            return items[indexPath.row]
        }
    }
}
