import UIKit

final class DetailsViewController: UIViewController {
  
  private let requestHandler: RequestHandling
  private let imageLoader: ImageLoader
  
  private let species: Species
  private let nameLabel = UILabel()
  private let imageView = UIImageView()
  private let detailsChainView = DetailsChainView()
  
  init(with species: Species,
       and requestHandler: RequestHandling,
       and imageLoader: ImageLoader) {
    self.species = species
    self.requestHandler = requestHandler
    self.imageLoader = imageLoader
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSubviews()
    fetchImage()
    
    fetchSinglePokemon { url in
      self.fetchEvolution(evalUrl: url)
    }
  }
  
}

private extension DetailsViewController {
  
  private func setupSubviews() {
    view.backgroundColor = .systemBackground
    UIScrollView().add(to: view).do {
      $0.topToSuperview(usingSafeArea: true)
      $0.leftToSuperview()
      $0.rightToSuperview()
      $0.bottomToSuperview(usingSafeArea: false)
      
      UIView().add(to: $0).do {
        $0.width(view.frame.width)
        $0.topToSuperview()
        $0.leftToSuperview()
        $0.rightToSuperview()
        $0.bottomToSuperview()
        
        imageView.add(to: $0).do {
          $0.topToSuperview(offset: 40)
          $0.leftToSuperview(offset: 40)
          $0.rightToSuperview(offset: -40)
          $0.aspectRatio(1)
        }
        
        detailsChainView.add(to: $0).do {
          $0.topToBottom(of: imageView, offset: 40)
          $0.leftToSuperview(offset: 40)
          $0.rightToSuperview(offset: -40)
          $0.bottomToSuperview(offset: -40)
          $0.height(600)
        }
      }
    }
    
    title = species.name
  }
  
}

private extension DetailsViewController {
  
  private func fetchImage() {
    imageLoader.obtainImage(with: species.url.pokemonId) { image in
      self.imageView.image = image
    }
  }
  
  func fetchSinglePokemon(completion: @escaping (URL) -> Void) {
    guard let spcUrl = URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(species.url.pokemonId)") else { return }
    
    let route = APIRoute.getSpecies(spcUrl)
    
    do {
      try requestHandler.request(route: route) { (result: Swift.Result<SpeciesDetails, Error>) in
        switch result {
          case .success(let response):
            completion(response.evolutionChain.url)
            
          case .failure(let error):
            // Handle the failure case and display the error
            print("Error: \(error.localizedDescription)")
        }
      }
    } catch {
      // Handle any errors thrown during the request
      print("Error: \(error.localizedDescription)")
    }
  }
  
  func fetchEvolution(evalUrl: URL) {
    let route = APIRoute.getEvolutionChain(evalUrl)
    
    do {
      try requestHandler.request(route: route) { (result: Swift.Result<EvolutionChainDetails, Error>) in
        switch result {
          case .success(let response):
            self.didFetchChain(response: response)
            
          case .failure(let error):
            // Handle the failure case and display the error
            print("Error: \(error.localizedDescription)")
        }
      }
    } catch {
      // Handle any errors thrown during the request
      print("Error: \(error.localizedDescription)")
    }
  }
  
  private func didFetchChain(response: EvolutionChainDetails) {
    let firstId = response.chain.species.url.pokemonId 
    let firstName = response.chain.species.name 
    
    let secondId = response.chain.evolvesTo.first?.species.url.pokemonId ?? -1
    let secondName = response.chain.evolvesTo.first?.species.name
    
    let thirdId = response.chain.evolvesTo.first?.evolvesTo.first?.species.url.pokemonId ?? -1
    let thirdName = response.chain.evolvesTo.first?.evolvesTo.first?.species.name
    
    DispatchQueue.main.async {
      self.detailsChainView.firstLabel.text = firstName
      self.detailsChainView.secondLabel.text = secondName
      self.detailsChainView.thirdLabel.text = thirdName
      
      self.imageLoader.obtainImage(with: firstId) { image in
        self.detailsChainView.firstImageView.image = image
      }
      self.imageLoader.obtainImage(with: secondId) { image in
        self.detailsChainView.secondImageView.image = image
      }
      self.imageLoader.obtainImage(with: thirdId) { image in
        self.detailsChainView.thirdImageView.image = image
      }
    }
  }
  
}
