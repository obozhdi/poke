import Foundation
/// Enum that encodes the endpoints of the poke-api, required for the assignment. Can be fed into the RequestHandler.
///
/// It makes sure you don't have to worry too much about writing down the requests, and instead focus on the request manager.
/// In the RequestManager, simply use `APIRoute.asRequest()` to get the URLRequest to perform.
enum APIRoute {
  
  case getSpeciesList(limit: Int, offset: Int)
  case getSpecies(URL)
  case getEvolutionChain(URL)
  
  private var baseURLString: String { "https://pokeapi.co/api/v2/" }
  static var baseImageURLString = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
  
  private var url: URL? {
    switch self {
      case .getSpecies(let url), .getEvolutionChain(let url):
        return url
      case .getSpeciesList:
        return URL(string: baseURLString + "pokemon-species")
    }
  }
  
  private var parameters: [URLQueryItem] {
    switch self {
      case .getSpeciesList(let limit, let offset):
        return [
          URLQueryItem(name: "limit", value: String(limit)),
          URLQueryItem(name: "offset", value: String(offset))
        ]
      default:
        return []
    }
  }
  
  func asRequest() -> URLRequest {
    guard let url = url else {
      preconditionFailure("Missing URL for route: \(self)")
    }
    
    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    components?.queryItems = parameters
    
    guard let parametrizedURL = components?.url else {
      preconditionFailure("Missing URL with parameters for url: \(url)")
    }
    
    return URLRequest(url: parametrizedURL, cachePolicy: .returnCacheDataElseLoad)
  }
  
}
