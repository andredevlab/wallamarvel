import Foundation

final class MarvelRepositoryImpl: MarvelRepository {
    private let dataSource: MarvelRemoteDataSource
    
    init(dataSource: MarvelRemoteDataSource) {
        self.dataSource = dataSource
    }
    
    func getHeroes(completionBlock: @escaping (Result<[CharacterModel], Error>) -> Void) {
        dataSource.getHeroes { result in
            switch result {
            case .success(let dataContainer):
                completionBlock(.success(CharacterMapper.map(dataContainer.characters)))
            case .failure(let error):
                completionBlock(.failure(error))
            }  
        }
    }
}
