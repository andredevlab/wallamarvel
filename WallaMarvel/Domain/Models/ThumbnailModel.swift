import Foundation

struct ThumbnailModel {
    let path: String
    let `extension`: String
    
    init?(path: String?, `extension`: String?) {
        guard let path, let `extension` else { return nil }
        self.path = path
        self.`extension` = `extension`
    }
}
