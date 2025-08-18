import Foundation

public class CharacterServiceFactory {
    static public func make() -> CharacterService {
//        return CharacterServiceMock()
        return CharacterServiceImpl(client: RickAndMortyAPIClientImpl())
//        CharacterServiceWithMockFallback(characterService: CharacterServiceImpl(client: APIClientImpl()),
//                                         mockService: CharacterServiceMock())
        
    }
}
