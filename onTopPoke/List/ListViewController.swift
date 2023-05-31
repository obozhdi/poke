import UIKit

final class ListViewController: UIViewController {
  
  private var page = 0
  
  private let imageLoader = ImageLoader()
  private let requestHandler: RequestHandling = RequestHandler()
  private var species: [Species] = []
  
  private var shouldRequestNext: Bool = true
  
  private var collectionView: UICollectionView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSubviews()
    
    fetchSpecies()
  }
  
}

private extension ListViewController {
  
  private func fetchSpecies() {
    do {
      try requestHandler.request(route: .getSpeciesList(limit: 20, offset: species.count)) { [weak self] (result: Swift.Result<SpeciesResponse, Error>) in
        DispatchQueue.main.async {
          switch result {
            case .success(let response):
              self?.didFetchSpecies(response: response)
            case .failure:
              print("TODO handle network failures")
          }
        }
      }
    } catch {
      print("TODO handle request handling failures")
    }
  }
  
  private func didFetchSpecies(response: SpeciesResponse) {
    DispatchQueue.main.async {
      let initialCount = self.species.count
      self.species += response.results
      
      var arr: [IndexPath] = []
      
      for i in initialCount..<self.species.count {
        arr.append(IndexPath(item: i, section: 0))
      }
      
      self.collectionView?.performBatchUpdates({
        self.collectionView?.insertItems(at: arr)
      })
      self.page += 1
      self.shouldRequestNext = true
    }
  }
  
  private func loadNextPage() {
    if shouldRequestNext {
      self.fetchSpecies()
      shouldRequestNext = false
    }
  }
  
}

private extension ListViewController {
  
  private func setupSubviews() {
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 20,
                                       left: 10,
                                       bottom: 10,
                                       right: 10)
    layout.itemSize = CGSize(width: (view.frame.size.width - 30) / 2,
                             height: view.frame.size.width / 2)
    
    collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    collectionView?.dataSource = self
    collectionView?.delegate = self
    collectionView?.register(ListCell.self,
                             forCellWithReuseIdentifier: String(describing: ListCell.self))
    collectionView?.backgroundColor = UIColor.white
    collectionView?.showsVerticalScrollIndicator = false
    view.addSubview(collectionView ?? UIView())
    
    title = "POKéMON"
  }
  
}

extension ListViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    species.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ListCell.self),
                                                  for: indexPath) as? ListCell
    cell?.setData(with: species[indexPath.item])

    imageLoader.cancel(with: species[indexPath.item].url.pokemonId)
    cell?.tag = species[indexPath.item].url.pokemonId
    cell?.imageView.image = nil
    imageLoader.obtainImage(with: species[indexPath.item].url.pokemonId) { image in
      cell?.imageView.image = image
    }
    
    if indexPath.item > species.count - 10 { loadNextPage() }
    
    return cell ?? UICollectionViewCell()
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    navigationController?.pushViewController(DetailsViewController(with: species[indexPath.item],
                                                                   and: requestHandler,
                                                                   and: imageLoader),
                                             animated: true)
  }
  
}
