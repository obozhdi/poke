//
//  onTopPokeTests.swift
//  onTopPokeTests
//
//  Created by Artem Pashkov on 31/05/2023.
//

import XCTest
@testable import onTopPoke

final class onTopPokeTests: XCTestCase {
  
  override func setUpWithError() throws {}
  
  override func tearDownWithError() throws {}
  
  func testProperIdExtractionFromUrl() throws {
    let urlStrings = [URL(string: "https://pokeapi.co/api/v2/pokemon-species/1/")!,
                      URL(string: "https://pokeapi.co/api/v2/pokemon-species/2")!,
                      URL(string: "https://pokeapi.co/api/v2/pokemon-species/3/")!,
                      URL(string: "https://pokeapi.co/api/v2/pokemon-species/4")!,
                      URL(string: "https://pokeapi.co/api/v2/pokemon-species/44")!,
                      URL(string: "https://pokeapi.co/api/v2/pokemon-species/4444/")!]
    
    let expectedValues = [1, 2, 3, 4, 44, 4444]
    for (urlString, expectedValue) in zip(urlStrings, expectedValues) {
      let string = urlString
      let value = expectedValue
      
      XCTAssertTrue(string.pokemonId == value)
    }
  }
  
  func testFetchName() throws {
    let requestHandler = RequestHandler()
    
    let expectedNamesList = ["bulbasaur", "ivysaur", "venusaur", "charmander", "charmeleon"]
    var fetchedNames: [String] = []
    
    let expectation = XCTestExpectation(description: "Wait for network response")
    
    do {
      try requestHandler.request(route: .getSpeciesList(limit: 5, offset: 0)) { (result: Swift.Result<SpeciesResponse, Error>) in
        DispatchQueue.main.async {
          switch result {
            case .success(let response):
              let objects = response.results
              for object in objects {
                fetchedNames.append(object.name)
              }
              expectation.fulfill()
              
            case .failure:
              print("TODO handle network failures")
          }
        }
      }
    } catch {
      print("TODO handle request handling failures")
    }
    
    wait(for: [expectation], timeout: 5)
    
    XCTAssertEqual(expectedNamesList, fetchedNames)
  }
  
  
  
}
