import Foundation

struct CharacterListItemViewModel: Hashable {
    let id: Int
    let name: String
    let imageURL: URL
    let location: String
    let species: String
    let status: String
    
    init(model: CharacterModel) {
        id = model.id
        name = model.name
        imageURL = model.image
        location = model.location.name
        species = model.species
        status = model.status
    }
}

extension CharacterListItemViewModel: CharacterListVisitableItem {
    func accept(_ visitor: CharacterListItemVisitor) {
        visitor.visit(self)
    }
}
