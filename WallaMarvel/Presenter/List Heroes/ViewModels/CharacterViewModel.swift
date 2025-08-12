import Foundation

struct CharacterViewModel: Hashable {
    let id: Int
    let name: String
    let imageURL: URL
    
    init(model: CharacterModel) {
        id = model.id
        name = model.name
        imageURL = model.image
    }
}
