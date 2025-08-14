import Foundation
import CoreNetwork

protocol CharacterRemoteDataSource {
    func fetchAll(page: Int) async throws -> CharacterResponseDTO
    func fetchCharacter(id: Int) async throws -> CharacterDTO
}
