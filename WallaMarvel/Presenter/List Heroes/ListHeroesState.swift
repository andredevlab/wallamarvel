import Foundation

enum ListHeroesState {
    case idle
    case loading
    case loaded(dataProvider: CharacterListDataProvider)
    case empty
    case error(Error)
}
