import Foundation
import Combine

enum CharacterDetailState {
    case idle
    case loading
    case success(CharacterModel)
    case failure(message: String)
}

protocol CharacterDetailPresenter: ObservableObject {
    var state: CharacterDetailState { get }
    func loadCharacter(with id: Int) async
}

final class CharacterDetailPresenterImpl: CharacterDetailPresenter {
    @Published private(set) var state: CharacterDetailState = .idle
    
    private let getCharacterUseCase: GetCharacterUseCase
    
    init(getCharacterUseCase: GetCharacterUseCase) {
        self.getCharacterUseCase = getCharacterUseCase
    }
    
    func loadCharacter(with id: Int) async {
        await MainActor.run { state = .loading }
        
        do {
            let character = try await getCharacterUseCase.execute(id: id)
            await MainActor.run { state = .success(character) }
        } catch {
            await MainActor.run { state = .failure(message: "Couldn’t load character.") }
        }
    }
}
