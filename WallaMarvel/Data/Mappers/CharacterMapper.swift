import Foundation

struct CharacterMapper {
    static func map(_ dto: CharacterDTO) -> CharacterModel {
        CharacterModel(
            id: dto.id,
            name: dto.name,
            thumbnail: ThumbnailModel(path: dto.thumbnail.path,
                                      extension: dto.thumbnail.extension)
        )
    }
    
    static func map(_ dtos: [CharacterDTO]) -> [CharacterModel] {
        dtos.map { map($0) }
    }
}
