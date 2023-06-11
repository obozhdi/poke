import Foundation
import UIKit

class ImageLoader: NSObject, URLSessionDelegate {
  
  private let imageCache = NSCache<NSString, UIImage>()
  private let loadImageQueue = OperationQueue()
  private let urlSession: URLSession
  private var loadOperations = [Int: LoadImageOperation]()
  
  override init() {
    loadImageQueue.maxConcurrentOperationCount = 6
    let sessionConfiguration = URLSessionConfiguration.default
    urlSession = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: nil)
    super.init()
  }
  
  func obtainImage(with id: Int, finishBlock: @escaping (UIImage?) -> Void) {
    if let image = imageCache.object(forKey: "\(id)" as NSString) {
      DispatchQueue.main.async { finishBlock(image) }
    } else {
      let loadImageOperation = LoadImageOperation(imageURL: APIRoute.baseImageURLString + "\(id).png",
                                                  imageCache: imageCache,
                                                  urlSession: urlSession) { [weak self] image in
        guard let self = self else { return }
        DispatchQueue.main.async { finishBlock(image) }
        self.loadOperations.removeValue(forKey: id)
      }
      loadOperations[id] = loadImageOperation
      loadImageQueue.addOperation(loadImageOperation)
    }
  }
  
  func cancel(with id: Int?) {
    loadOperations.removeValue(forKey: id ?? -1)?.cancel()
  }
  
}
