import Foundation

actor CharacterLocalDataSourceImpl: CharacterLocalDataSource {
    private let fileManager: FileManager = .default
    private let dirURL: URL
    
    init(folderName: String = "cache_characters") {
        let caches = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.dirURL = caches.appendingPathComponent(folderName, isDirectory: true)
        try? fileManager.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    func fetchAll(page: Int) async throws -> [CharacterModel] {
        let fileURL = urlForPage(page)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            throw CharacterDataSourceError.unavailable
        }
        
        let data = try Data(contentsOf: fileURL)
        do {
            return try JSONDecoder().decode([CharacterModel].self, from: data)
        } catch {
            throw error
        }
    }
    
    func save(page: Int, characters: [CharacterModel]) async {
        let fileURL = urlForPage(page)
        if let data = try? JSONEncoder().encode(characters) {
            try? data.write(to: fileURL, options: [.atomic])
        }
    }
    
    // MARK: - Helpers
    private func urlForPage(_ page: Int) -> URL {
        dirURL.appendingPathComponent("page_\(page).json", isDirectory: false)
    }
}
