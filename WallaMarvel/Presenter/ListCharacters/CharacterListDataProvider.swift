import UIKit

final class CharacterListDataProvider {
    enum Section {
        case main
    }
    
    enum Item: Hashable {
        case characterItem(id: Int)
        case listState(state: CharacterListState)
    }
    
    private var allItems: [CharacterListItemViewModel] = []
    private var items: [CharacterListItemViewModel] {
        switch currentFilter {
        case .name(let name):
            let name = name.lowercased()
            return allItems.filter { $0.name.lowercased().contains(name) }
        case .none:
            return allItems
        }
    }
    
    private var lastItemState: CharacterListState?
    private var currentFilter: CharacterListFilter = .none
    
    func update(items newItems: [CharacterListItemViewModel]) {
        allItems.append(contentsOf: newItems)
    }
    
    func apply(filter: CharacterListFilter) {
        currentFilter = filter
    }
    
    func snapshot(with listState: CharacterListState) -> NSDiffableDataSourceSnapshot<Section, Item> {
        lastItemState = listState
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        
        if listState != .loadingFilter {
            snapshot.appendItems(items.map { .characterItem(id: $0.id) }, toSection: .main)
        }
        
        if currentFilter == .none || listState == .loadingFilter {
            snapshot.appendItems([.listState(state: listState)], toSection: .main)
        }
        
        return snapshot
    }
    
    func visitableItem(for indexPath: IndexPath) -> (any CharacterListVisitableItem)? {
        guard indexPath.row >= 0, indexPath.row <= items.count else { return nil }
        
        if let lastItemState, lastItemState == .loadingFilter {
            return CharacterListStateViewModel(id: UUID(), state: lastItemState)
        }
        
        if indexPath.row == items.count {
            return CharacterListStateViewModel(id: UUID(), state: lastItemState ?? .idle)
        } else {
            return items[indexPath.row]
        }
    }
}
