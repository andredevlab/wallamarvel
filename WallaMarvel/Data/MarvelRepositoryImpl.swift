import Foundation

final class MarvelRepositoryImpl: MarvelRepository {
    private let dataSource: MarvelRemoteDataSource
    
    init(dataSource: MarvelRemoteDataSource) {
        self.dataSource = dataSource
    }
    
    func fetchCharacters(offset: Int, limit: Int) async throws -> [CharacterModel] {
        let characterObjects = try await dataSource.fetchCharacters(offset: offset, limit: limit)
        return CharacterMapper.map(characterObjects)
    }
}
