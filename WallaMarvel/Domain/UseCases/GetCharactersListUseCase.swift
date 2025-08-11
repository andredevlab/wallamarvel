import Foundation

protocol GetCharactersListUseCase {
    func execute(completionBlock: @escaping (Result<[CharacterModel], Error>) -> Void)
}
