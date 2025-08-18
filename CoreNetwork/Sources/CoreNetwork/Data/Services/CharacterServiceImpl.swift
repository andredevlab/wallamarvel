import Foundation

final class CharacterServiceImpl: CharacterService {
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func fetchCharacters(page: Int) async throws -> CharacterResponseDTO {
        try await client.send(CharacterRequest.list(page: page),
                              timeInterval: Date().timeIntervalSince1970)
    }
    
    func fetchCharacter(id: Int) async throws -> CharacterDTO {
        try await client.send(CharacterRequest.detail(id: id),
                              timeInterval: Date().timeIntervalSince1970)
    }
}
