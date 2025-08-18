import Foundation

@testable import CoreNetwork

extension Helper {
    static func makeCharacterResponseDTOInfoDTO(count: Int = 0,
                                                pages: Int = 0,
                                                next: String? = nil,
                                                prev: String? = nil) -> CharacterResponseDTO.InfoDTO {
        CharacterResponseDTO.InfoDTO(count: count, pages: pages, next: next, prev: prev)
    }
    static func makeCharacterResponseDTO(info: CharacterResponseDTO.InfoDTO = Helper.makeCharacterResponseDTOInfoDTO(),
                                         results: [CharacterDTO] = []) -> CharacterResponseDTO {
        CharacterResponseDTO(info: info, results: results)
    }
    
    static func makeCharacterDTO(id: Int = 0,
                                 name: String = "",
                                 image: URL = URL(string: "https://example.com/image.png")!,
                                 status: String = "unknown",
                                 species: String = "",
                                 type: String = "",
                                 gender: String = "",
                                 origin: CharacterDTO.PlaceDTO = .init(name: "", url: ""),
                                 location: CharacterDTO.PlaceDTO = .init(name: "", url: ""),
                                 episode: [String] = [],
                                 url: String = "",
                                 created: String = "") -> CharacterDTO {
        CharacterDTO(id: id,
                     name: name,
                     image: image,
                     status: status,
                     species: species,
                     type: type,
                     gender: gender,
                     origin: origin,
                     location: location,
                     episode: episode,
                     url: url,
                     created: created
        )
    }
    
}
