import UIKit

final class CharacterListDataProvider {
    enum Section {
        case main
    }
    
    enum Item: Hashable {
        case characterItem(CharacterViewModel)
    }

    private var items: [CharacterViewModel] = []
    
    func update(items newItems: [CharacterViewModel]) {
        items.append(contentsOf: newItems)
    }
    
    func snapshot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items.map { Item.characterItem($0) }, toSection: .main)
        return snapshot
    }
}
