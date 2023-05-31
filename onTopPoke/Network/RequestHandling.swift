import Foundation
/// Protocol for the `RequestHandler` you will build.
///
/// It's fine to change the signature of the request method, for example by adding a `where` clause to constrain the generic `T`.
/// More elaborate changes are also required, but try to make sure the `RequestHandler` is generalized enough to work on potential new `APIRoute`s as well.
protocol RequestHandling {
  
  func request<T: Decodable>(route: APIRoute,
                             completion: @escaping (Swift.Result<T, Error>) -> Void) throws
  
}
