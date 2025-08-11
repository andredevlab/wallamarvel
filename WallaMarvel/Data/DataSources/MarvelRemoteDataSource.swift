import Foundation
import CoreNetwork

protocol MarvelRemoteDataSource {
    func fetchCharacters(offset: Int, limit: Int) async throws -> [CharacterDTO]
}
