import Foundation

enum MarvelDataSourceError: LocalizedError {
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "An unknown error occurred. Please try again."
        }
    }
}
