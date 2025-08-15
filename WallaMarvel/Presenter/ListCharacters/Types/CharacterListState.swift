import Foundation

enum CharacterListState {
    case idle
    case loadMore
    case loadingMore
    case loadingFilter
    case error
    case reachEnd
    case empty
}
