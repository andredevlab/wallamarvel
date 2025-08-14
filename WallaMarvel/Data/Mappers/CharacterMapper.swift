import Foundation
import CoreNetwork

struct CharacterMapper {
    static func map(_ dto: CharacterDTO) -> CharacterModel {
        CharacterModel(id: dto.id,
                       name: dto.name,
                       image: dto.image,
                       status: dto.status,
                       species: dto.species,
                       type: dto.type,
                       gender: dto.gender,
                       origin: LocationModel(name: dto.origin.name, url: dto.origin.url),
                       location: LocationModel(name: dto.location.name, url: dto.location.url),
                       episode: dto.episode.compactMap { $0 },
                       url: dto.url,
                       created: dto.created)
    }
    
    static func map(_ dtos: [CharacterDTO]) -> [CharacterModel] {
        dtos.map { map($0) }
    }
}
