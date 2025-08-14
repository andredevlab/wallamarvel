import Foundation

struct CharacterListStateViewModel: Hashable {
    let id: UUID
    var state: CharacterListState
}

extension CharacterListStateViewModel: CharacterListVisitableItem {
    func accept(_ visitor: CharacterListItemVisitor) {
        visitor.visit(self)
    }
}
