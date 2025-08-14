import Foundation

struct CharacterListItemViewModel: Hashable {
    let id: Int
    let name: String
    let imageURL: URL
    
    init(model: CharacterModel) {
        id = model.id
        name = model.name
        imageURL = model.image
    }
}

extension CharacterListItemViewModel: CharacterListVisitableItem {
    func accept(_ visitor: CharacterListItemVisitor) {
        visitor.visit(self)
    }
}
