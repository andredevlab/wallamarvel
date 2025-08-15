import SwiftUI

final class CharacterDetailFactory {
    private let characterRepository: CharacterRepository
    
    init(characterRepository: CharacterRepository) {
        self.characterRepository = characterRepository
    }
    
    func make(id: Int) -> UIViewController {
        let getCharacterUseCaseImpl = GetCharacterUseCaseImpl(repository: characterRepository)
        let presenter = CharacterDetailPresenterImpl(getCharacterUseCase: getCharacterUseCaseImpl)
        let view = CharacterDetailView(presenter: presenter, characterId: id)
        return UIHostingController(rootView: view)
    }
}
