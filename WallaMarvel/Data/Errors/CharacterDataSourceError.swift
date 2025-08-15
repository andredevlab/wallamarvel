import Foundation

enum CharacterDataSourceError: LocalizedError {
    case unknown
    case unavailable
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "An unknown error occurred. Please try again."
        case .unavailable:
            return "The resource is not available"
        }
    }
}
