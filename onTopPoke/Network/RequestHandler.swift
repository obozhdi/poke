import Foundation

class RequestHandler: RequestHandling {
  lazy var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }()
  
  func request<T: Decodable>(route: APIRoute, completion: @escaping (Swift.Result<T, Error>) -> Void) throws {
    let urlRequest = route.asRequest()
    URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard let data = data else {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Data was not retrieved from request"]) as Error
        completion(.failure(error))
        return
      }
      
      do {
        let object = try self.decoder.decode(T.self, from: data)
        completion(.success(object))
      } catch let error {
        completion(.failure(error))
      }
    }.resume()
  }
}
