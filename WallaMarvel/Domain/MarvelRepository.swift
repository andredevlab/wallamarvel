import Foundation

protocol MarvelRepository {
    func getHeroes(completionBlock: @escaping (Result<[CharacterModel], Error>) -> Void)
}
