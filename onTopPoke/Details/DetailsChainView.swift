import UIKit

final class DetailsChainView: UIView {
  
  let firstImageView = UIImageView()
  let secondImageView = UIImageView()
  let thirdImageView = UIImageView()
  
  let firstLabel = UILabel()
  let secondLabel = UILabel()
  let thirdLabel = UILabel()
  
  var highlightedIndex: Int = 0
  
  override init(frame: CGRect) { super.init(frame: frame); setupSubviews() }
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
}

private extension DetailsChainView {
  
  private func setupSubviews() {
    let firstView = UIView().add(to: self).then {
      $0.topToSuperview()
      $0.leftToSuperview()
      $0.rightToSuperview()
      $0.heightToSuperview(multiplier: 0.33)
      
      firstImageView.add(to: $0).do {
        $0.topToSuperview(offset: 20)
        $0.leftToSuperview(offset: 20)
        $0.bottomToSuperview(offset: -20)
        $0.aspectRatio(1)
      }
      
      firstLabel.add(to: $0).do {
        $0.centerY(to: firstImageView)
        $0.leftToRight(of: firstImageView, offset: 20)
        $0.rightToSuperview(offset: -20)
        $0.numberOfLines = 0
      }
    }
    
    let secondView = UIView().add(to: self).then {
      $0.topToBottom(of: firstView)
      $0.leftToSuperview()
      $0.rightToSuperview()
      $0.heightToSuperview(multiplier: 0.33)
      
      secondImageView.add(to: $0).do {
        $0.topToSuperview(offset: 20)
        $0.leftToSuperview(offset: 20)
        $0.bottomToSuperview(offset: -20)
        $0.aspectRatio(1)
      }
      
      secondLabel.add(to: $0).do {
        $0.centerY(to: secondImageView)
        $0.leftToRight(of: secondImageView, offset: 20)
        $0.rightToSuperview(offset: -20)
        $0.numberOfLines = 0
      }
    }
    
    UIView().add(to: self).do {
      $0.topToBottom(of: secondView)
      $0.leftToSuperview()
      $0.rightToSuperview()
      $0.heightToSuperview(multiplier: 0.33)
      
      thirdImageView.add(to: $0).do {
        $0.topToSuperview(offset: 20)
        $0.leftToSuperview(offset: 20)
        $0.bottomToSuperview(offset: -20)
        $0.aspectRatio(1)
      }
      
      thirdLabel.add(to: $0).do {
        $0.centerY(to: thirdImageView)
        $0.leftToRight(of: thirdImageView, offset: 20)
        $0.rightToSuperview(offset: -20)
        $0.numberOfLines = 0
      }
    }
  }
  
}
