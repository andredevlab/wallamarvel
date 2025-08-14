import Foundation

final class CharacterRepositoryImpl: CharacterRepository {
    private let remoteDataSource: CharacterRemoteDataSource
    private let localDataSource: CharacterLocalDataSource
    
    private var currentPage = 1
    private var hasMoreToLoad: Bool = true
    
    init(remoteDataSource: CharacterRemoteDataSource, localDataSource: CharacterLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func hasMoreCharactersToLoad() -> Bool {
        hasMoreToLoad
    }
    
    func fetchCharacters() async throws -> [CharacterModel] {
        do {
            let cachedModels = try await localDataSource.fetchAll(page: currentPage)
            currentPage += 1
            return cachedModels
        } catch let error as CharacterDataSourceError where error == .unavailable {
            let response = try await remoteDataSource.fetchAll(page: currentPage)
            hasMoreToLoad = currentPage < response.info.pages
            let models = CharacterMapper.map(response.results)
            await localDataSource.save(page: currentPage, characters: models)
            currentPage += 1
            return models
        } catch {
            throw error
        }
    }
    
    func fetchCharacter(id: Int) async throws -> CharacterModel {
        let dto = try await remoteDataSource.fetchCharacter(id: id)
        return CharacterMapper.map(dto)
    }
}
