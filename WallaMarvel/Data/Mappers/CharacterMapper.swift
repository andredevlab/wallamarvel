import Foundation
import CoreNetwork

struct CharacterMapper {
    static func map(_ dto: CharacterDTO) -> CharacterModel {
        CharacterModel(id: dto.id,
                       name: dto.name,
                       image: dto.image)
    }
    
    static func map(_ dtos: [CharacterDTO]) -> [CharacterModel] {
        dtos.map { map($0) }
    }
}
