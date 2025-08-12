import UIKit

final class CharacterListDataProvider {
    enum Section {
        case main
    }
    
    enum Item: Hashable {
        case characterItem(CharacterViewModel)
        case listState(ListState)
    }
    
    enum ListState {
        case loadMore
        case loading
        case error
        case reachEnd
        case empty
    }

    private var items: [CharacterViewModel] = []
    
    func update(items newItems: [CharacterViewModel]) {
        items.append(contentsOf: newItems)
    }
    
    func snapshot(with listState: ListState) -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items.map { Item.characterItem($0) }, toSection: .main)
        snapshot.appendItems([.listState(items.isEmpty ? .empty : listState)], toSection: .main)
        return snapshot
    }
}
