import Foundation

final class CharacterLocalDataSourceImpl: CharacterLocalDataSource {
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
        return try JSONDecoder().decode([CharacterModel].self, from: data)
    }
    
    func save(page: Int, characters: [CharacterModel]) async {
        let fileURL = urlForPage(page)
        if let data = try? JSONEncoder().encode(characters) {
            try? data.write(to: fileURL, options: [.atomic])
        }
    }
    
    func fetch(id: Int) async throws -> CharacterModel {
        let fileURL = urlForCharacterId(id)
        guard fileManager.fileExists(atPath: fileURL.path) else {
            throw CharacterDataSourceError.unavailable
        }
        
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(CharacterModel.self, from: data)
    }
    
    func save(character: CharacterModel) async {
        let fileURL = urlForCharacterId(character.id)
        if let data = try? JSONEncoder().encode(character) {
            try? data.write(to: fileURL, options: [.atomic])
        }
    }
    
    // MARK: - Helpers
    
    private func urlForPage(_ page: Int) -> URL {
        dirURL.appendingPathComponent("page_\(page).json", isDirectory: false)
    }
    private func urlForCharacterId(_ id: Int) -> URL {
        dirURL.appendingPathComponent("character_id_\(id).json", isDirectory: false)
    }
}
