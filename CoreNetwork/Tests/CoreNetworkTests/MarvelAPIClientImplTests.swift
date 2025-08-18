import Foundation
import XCTest

@testable import CoreNetwork

final class MarvelAPIClientImplTests: XCTestCase {
    
    typealias SUT = MarvelAPIClientImpl
    
    private var sut: SUT!
    private var urlSession: URLSession!
    
    override func setUp() {
        super.setUp()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        urlSession = URLSession(configuration: config)

        sut = .init(session: urlSession, publicKey: "1234", privateKey: "abcd")
    }
    
    override func tearDown() {
        super.tearDown()
        MockURLProtocol.handler = nil
        urlSession = nil
        sut = nil
    }
    
    func test_CharacterRequestGetCharacters_shouldRequestURLSessionWithExpectedValues() async throws {
        // Intercepts requests without hitting the network
        MockURLProtocol.handler = { urlRequest in
            let url = try XCTUnwrap(urlRequest.url)
            XCTAssertEqual(url.scheme, "https")
            XCTAssertEqual(url.host, "gateway.marvel.com")
            XCTAssertEqual(url.path, "/v1/public/characters")
            XCTAssertEqual(urlRequest.httpMethod, "GET")
            
            let comps = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
            
            // Request-specific params
            XCTAssertEqual(comps.queryItems?.first { $0.name == "offset" }?.value as? String, "1111")
            XCTAssertEqual(comps.queryItems?.first { $0.name == "limit" }?.value as? String, "2222")

            // Marvel auth params (MD5("1abcd1234") from docs)
            XCTAssertEqual(comps.queryItems?.first { $0.name == "ts" }?.value as? String, "1")
            XCTAssertEqual(comps.queryItems?.first { $0.name == "apikey" }?.value as? String, "1234")
            XCTAssertEqual(comps.queryItems?.first { $0.name == "hash" }?.value as? String, "ffd275c5130566a2916217b101f26150")
            
            // Return a 401 to end the flow early (we're only validating the URL)
            let http = HTTPURLResponse(url: url, statusCode: 401, httpVersion: nil, headerFields: nil)!
            let body = Data(#"{"code":"InvalidCredentials"}"#.utf8)
            return (http, body)
        }
        
        do {
            _ = try await sut.send(MarvelCharacterRequest.getCharacters(offset: 1111, limit: 2222), timeInterval: 1)
            XCTFail("Expected 401 to stop after URL validation.")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
}
