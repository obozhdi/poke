import UIKit

final class ListCell: UICollectionViewCell {
  
  private let textLabel = UILabel()
  let imageView = UIImageView()
  
  override init(frame: CGRect) { super.init(frame: frame); setupSubviews() }
  required init?(coder: NSCoder) { super.init(coder: coder); setupSubviews() }
  
  override func prepareForReuse() { imageView.image = nil }
}

extension ListCell {
  
  func setData(with species: Species) {
    textLabel.text = species.name.capitalized
  }
  
}

private extension ListCell {
  
  private func setupSubviews() {
    contentView.layer.shadowColor = UIColor.black.cgColor
    contentView.layer.shadowOffset = CGSize(width: 0,
                                            height: 0.5)
    contentView.layer.shadowOpacity = 0.3
    contentView.layer.shadowRadius = 2
    contentView.clipsToBounds = false
    
    imageView.add(to: contentView).do {
      $0.edgesToSuperview()
      $0.contentMode = .scaleAspectFit
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 16
    }
    
    textLabel.add(to: contentView).do {
      $0.topToSuperview(offset: 8)
      $0.leftToSuperview(offset: 12)
    }
  }
  
}
