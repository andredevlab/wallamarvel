import Foundation

@testable import CoreNetwork

final class MockAPIClient: APIClient {
    
    var invocations = [Invocation]()
    var returns = [Invocation: Any?]()
    var characterRequest: Any?
    
    enum Invocation: Equatable, Hashable {
        case send
    }
    
    func send<T: APIRequest>(_ request: T, 
                             timeInterval: TimeInterval = Date().timeIntervalSince1970) async throws -> T.Response {
        let invocation: Invocation = .send
        characterRequest = request as? CharacterRequest<T.Response>
        
        invocations.append(invocation)
        
        guard let successReturn = returns[invocation] as? T.Response else {
            throw returns[invocation] as? Error ?? NSError(domain: "", code: 0)
        }
        
        return successReturn
    }
}
