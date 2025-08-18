import Foundation
import XCTest

@testable import CoreNetwork

final class CharacterServiceImplTests: XCTestCase {
    
    typealias SUT = CharacterServiceImpl
    
    private var sut: SUT!
    private var mockAPIClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        mockAPIClient = .init()
        sut = .init(client: mockAPIClient)
    }
    
    override func tearDown() {
        super.tearDown()
        mockAPIClient = nil
        sut = nil
    }
    
    func test_fetchCharacters_shouldRequestWithCharacterRequest() async throws {
        XCTAssertEqual(mockAPIClient.invocations, [])
        mockAPIClient.returns[.send] = Helper.makeCharacterResponseDTO()
        
        _ = try await sut.fetchCharacters(page: 1)
        
        XCTAssertEqual(mockAPIClient.invocations, [.send])
        XCTAssertNotNil(mockAPIClient.characterRequest)
    }
    
    func test_fetchCharacters_givenSuccessApiRequest_shouldPropagateExpectedValues() async throws {
        XCTAssertEqual(mockAPIClient.invocations, [])
        let expectedCharacterDTO = Helper.makeCharacterDTO(id: 0000,
                                                           name: "foo.name",
                                                           image: URL(string: "https://example.com/foo.png")!,
                                                           status: "foo.status",
                                                           species: "foo.species",
                                                           type: "foo.type",
                                                           gender: "foo.gender",
                                                           origin: .init(name: "foo.origin", 
                                                                         url: "https://example.com/foo.origin"),
                                                           location: .init(name: "foo.location", 
                                                                           url: "https://example.com/foo.location"),
                                                           episode: ["https://example.com/foo.episode"],
                                                           url: "https://example.com/foo",
                                                           created: "foo.created"
        )
        let expectedInfo = CharacterResponseDTO.InfoDTO(count: 1111,
                                                        pages: 2222,
                                                        next: "foo.next",
                                                        prev: "foo.prev")
        let characterResponseDTO = Helper.makeCharacterResponseDTO(info: expectedInfo, results: [expectedCharacterDTO])
        
        mockAPIClient.returns[.send] = characterResponseDTO
        
        let receivedDto = try await sut.fetchCharacters(page: 0)
        
        XCTAssertEqual(receivedDto.info.count, expectedInfo.count)
        XCTAssertEqual(receivedDto.info.next, expectedInfo.next)
        XCTAssertEqual(receivedDto.info.pages, expectedInfo.pages)
        XCTAssertEqual(receivedDto.info.prev, expectedInfo.prev)
        XCTAssertEqual(receivedDto.results.count, 1)
        
        guard let character = receivedDto.results.first else {
            XCTFail("Should receive one CharacterDTO")
            return
        }
        
        XCTAssertEqual(character.id, expectedCharacterDTO.id)
        XCTAssertEqual(character.name, expectedCharacterDTO.name)
        XCTAssertEqual(character.image, expectedCharacterDTO.image)
        XCTAssertEqual(character.status, expectedCharacterDTO.status)
        XCTAssertEqual(character.species, expectedCharacterDTO.species)
        XCTAssertEqual(character.type, expectedCharacterDTO.type)
        XCTAssertEqual(character.gender, expectedCharacterDTO.gender)
        XCTAssertEqual(character.origin, expectedCharacterDTO.origin)
        XCTAssertEqual(character.location, expectedCharacterDTO.location)
        XCTAssertEqual(character.episode, expectedCharacterDTO.episode)
        XCTAssertEqual(character.url, expectedCharacterDTO.url)
        XCTAssertEqual(character.created, expectedCharacterDTO.created)
        
        XCTAssertEqual(mockAPIClient.invocations, [.send])
    }
    
    func test_fetchCharacters_whenApiClientFails_shouldPropagateError() async throws {
        XCTAssertEqual(mockAPIClient.invocations, [])
        mockAPIClient.returns[.send] = NSError(domain: "foo.domain", code: 1111)
        do {
            _ = try await sut.fetchCharacters(page: 0)
            XCTFail("Should Fail")
        } catch {
            XCTAssertEqual((error as NSError).code, 1111)
            XCTAssertEqual((error as NSError).domain, "foo.domain")
        }
        
        XCTAssertEqual(mockAPIClient.invocations, [.send])
    }
}

