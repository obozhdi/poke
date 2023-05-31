import Foundation
import UIKit

class LoadImageOperation: Operation {
  
  private var mExecuting: Bool = false
  private var mFinished: Bool = false
  private var mCanceled: Bool = false
  
  private let imageURL: String
  private var sessionDataTask: URLSessionDataTask?
  private let urlSession: URLSession
  private let imageCache: NSCache<NSString, UIImage>
  
  var finishLoadImageBlock: ((UIImage?) -> Void)?
  
  init(imageURL: String, imageCache: NSCache<NSString, UIImage>, urlSession: URLSession, finishBlock: ((UIImage?) -> Void)?) {
    self.imageURL = imageURL
    self.imageCache = imageCache
    self.urlSession = urlSession
    self.finishLoadImageBlock = finishBlock
    
    super.init()
  }
  
  override var isAsynchronous: Bool { return true }
  override var isExecuting: Bool { return mExecuting }
  override var isFinished: Bool { return mFinished }
  
  override func cancel() {
    sessionDataTask?.cancel()
    mCanceled = true
  }
  
  override func start() {
    changeMExecuting(true)
    
    DispatchQueue.global(qos: .default).async { [weak self] in
      guard let self = self, let imgUrl = URL(string: self.imageURL) else { return }
      
      self.sessionDataTask = self.urlSession.dataTask(with: imgUrl) { [weak self] (data, response, error) in
        guard let self = self else { return }
        
        var loadImage: UIImage? = nil
        if let data = data {
          loadImage = UIImage(data: data)
          if let loadImage = loadImage {
            self.imageCache.setObject(loadImage, forKey: self.imageURL as NSString)
          }
        }
        
        DispatchQueue.main.async {
          if !self.mCanceled { self.finishLoadImageBlock?(loadImage) }
          self.changeMExecuting(false)
          self.changeMFinished(true)
        }
      }
      
      self.sessionDataTask?.resume()
    }
  }
  
  private func changeMExecuting(_ executing: Bool) {
    willChangeValue(forKey: "isExecuting")
    mExecuting = executing
    didChangeValue(forKey: "isExecuting")
  }
  
  private func changeMFinished(_ finished: Bool) {
    willChangeValue(forKey: "isFinished")
    mFinished = finished
    didChangeValue(forKey: "isFinished")
  }
  
}
