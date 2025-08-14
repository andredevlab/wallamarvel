import Foundation
import CoreNetwork

protocol CharacterRemoteDataSource {
    func fetchAll(page: Int) async throws -> CharacterResponseDTO
}

protocol CharacterLocalDataSource {
    func fetchAll(page: Int) async throws -> [CharacterModel]
    func save(page: Int, characters: [CharacterModel]) async
}
