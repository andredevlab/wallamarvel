import Foundation

protocol MarvelRepositoryProtocol {
    func getHeroes(completionBlock: @escaping (Result<CharacterDataContainer, Error>) -> Void)
}

final class MarvelRepository: MarvelRepositoryProtocol {
    private let dataSource: MarvelDataSourceProtocol
    
    init(dataSource: MarvelDataSourceProtocol = MarvelDataSource()) {
        self.dataSource = dataSource
    }
    
    func getHeroes(completionBlock: @escaping (Result<CharacterDataContainer, Error>) -> Void) {
        dataSource.getHeroes(completionBlock: completionBlock)
    }
}
