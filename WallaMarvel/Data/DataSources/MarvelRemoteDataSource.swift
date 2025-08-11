import Foundation

protocol MarvelRemoteDataSource {
    func getHeroes(completionBlock: @escaping (Result<CharacterContainerDTO, Error>) -> Void)
}
