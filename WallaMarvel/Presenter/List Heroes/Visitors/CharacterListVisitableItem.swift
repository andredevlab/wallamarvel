import Foundation

protocol CharacterListVisitableItem: Hashable {
    func accept(_ visitor: CharacterListItemVisitor)
}
