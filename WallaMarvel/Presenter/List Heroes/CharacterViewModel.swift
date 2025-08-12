import Foundation

struct CharacterViewModel: Hashable {
    let id: Int
    let name: String
    let thumbnailPath: String?
    let thumbnailExtension: String?
    
    init(model: CharacterModel) {
        id = model.id
        name = model.name
        thumbnailPath = model.thumbnail?.path
        thumbnailExtension = model.thumbnail?.extension
    }
}
