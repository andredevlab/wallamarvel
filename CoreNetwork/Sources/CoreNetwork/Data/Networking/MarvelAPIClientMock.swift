import Foundation

final class MarvelAPIClientMock: APIClient {
    func send<T: APIRequest>(_ request: T, timeInterval: TimeInterval) async throws -> T.Response {
        if request.path == "/v1/public/characters" {
            let data = Data(mockCharactersJSON.utf8)
            return try JSONDecoder().decode(T.Response.self, from: data)
        }
        throw NetworkError.badResponse
    }
    
    private let mockCharactersJSON = """
    {
      "code": 200,
      "status": "Ok",
      "data": {
        "offset": 0,
        "limit": 20,
        "total": 2,
        "count": 2,
        "results": [
          {
            "id": 1011334,
            "name": "3-D Man",
            "description": "",
            "modified": "2014-04-29T14:18:17-0400",
            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1011334",
            "thumbnail": {
              "path": "http://i.annihil.us/u/prod/marvel/i/mg/6/20/5232158de5b16",
              "extension": "jpg"
            },
            "comics": { "available": 12, "collectionURI": "", "items": [], "returned": 12 },
            "series": { "available": 3, "collectionURI": "", "items": [], "returned": 3 },
            "stories": { "available": 21, "collectionURI": "", "items": [], "returned": 20 },
            "events": { "available": 1, "collectionURI": "", "items": [], "returned": 1 },
            "urls": [ { "type": "detail", "url": "http://marvel.com/characters/74/3-d_man" } ]
          },
          {
            "id": 1017100,
            "name": "A-Bomb",
            "description": "Rick Jones has been Hulk's best bud since day one.",
            "modified": "2013-09-18T15:54:04-0400",
            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1017100",
            "thumbnail": {
              "path": "http://i.annihil.us/u/prod/marvel/i/mg/3/20/5232158de5b16",
              "extension": "jpg"
            },
            "comics": { "available": 4, "collectionURI": "", "items": [], "returned": 4 },
            "series": { "available": 2, "collectionURI": "", "items": [], "returned": 2 },
            "stories": { "available": 7, "collectionURI": "", "items": [], "returned": 7 },
            "events": { "available": 0, "collectionURI": "", "items": [], "returned": 0 },
            "urls": [ { "type": "detail", "url": "http://marvel.com/characters/76/a-bomb" } ]
          }
        ]
      }
    }
    """
}
