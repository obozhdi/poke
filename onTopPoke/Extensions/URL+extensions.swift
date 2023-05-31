import Foundation

extension URL {
  
  var pokemonId: Int {
    let urlString = self.absoluteString
    let pattern = "pokemon-species/(\\d+)/?$"
    let regex = try? NSRegularExpression(pattern: pattern)
    let range = NSRange(location: 0, length: urlString.utf16.count)
    
    if let match = regex?.firstMatch(in: urlString, options: [], range: range) {
        let idRange = match.range(at: 1)
        if let swiftRange = Range(idRange, in: urlString) {
            let idString = String(urlString[swiftRange])
          return Int(idString) ?? -1
        }
    }
    
    return -1
  }
  
  var pokemonImageUrl: URL? {
    URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(self.pokemonId).png")
  }
  
  var pokemonImageUrlString: String? {
    "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(self.pokemonId).png"
  }
  
}
