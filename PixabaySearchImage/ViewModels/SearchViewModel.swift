//
//  SearchViewModel.swift
//  PixabaySearchImage
//
//  Created by Majdi Felah on 16/04/20.
//  Copyright © 2020 Majdi Felah. All rights reserved.
//

import Foundation

final class SearchViewModel {

  private let webservice: WebserviceProtocol
  let cacheManager: PBImageCacheManager

  init(webservice: WebserviceProtocol = Webservice(),
       cacheManager: PBImageCacheManager = PBMainCacheManager.imageResultsCacheManager) {
    self.webservice = webservice
    self.cacheManager = cacheManager
  }

  /// User entered search term
  var searchTerm: String?

  /// Search results for the given searchTerm
  private(set) var results: [PBImage]?

  /// Checks if searchTerm is non-empty
  /// - Returns: true, if searchTerm is non-empty, else false
  func isSearchTermEmpty() -> Bool {
    guard let searchTerm = self.searchTerm else { return true }
    return searchTerm.trimmingCharacters(in: .whitespaces).isEmpty
  }

  func getResults(_ completion: @escaping (SearchError?) -> Void) {
    guard !self.isSearchTermEmpty(),
      let searchTerm = self.searchTerm?.trimmingCharacters(in: .whitespaces) else {
        completion(.emptySearchTerm)
      return
    }

    if let cached = self.cacheManager.getItem(by: searchTerm, type: [PBImage].self) {
      self.results = cached
      completion(nil)
      return
    }

    self.webservice.getResults(for: searchTerm) { (result) in
      DispatchQueue.main.async {
        switch result {
        case .failure(let error): completion(.requestFailed(error.localizedDescription))
        case .success(let images):
          self.results = images
          self.cacheManager.insert(value: images, for: searchTerm)
          completion(nil)
        }
      }
    }
  }
}

extension SearchViewModel {

  enum SearchError: Error {
    case emptySearchTerm
    case requestFailed(String)

    var description: String {
      switch self {
      case .emptySearchTerm: return "Please enter search term."
      case .requestFailed(let message): return message
      }
    }
  }
}
