//
//  Webservice.swift
//  PixabaySearchImage
//
//  Created by Majdi Felah on 16/04/20.
//  Copyright © 2020 Majdi Felah. All rights reserved.
//

import Foundation

struct ImagesAPIResponse: Decodable {
  var hits: [PBImage]
}

final class Webservice: WebserviceProtocol {

  private let client: NetworkClient

  init(client: NetworkClient = .init()) {
    self.client = client
  }

  func getResults(for searchTerm: String, completion: @escaping ResultsCompletionHandler) {
    let url = URL(string: "https://pixabay.com/api/?key=13197033-03eec42c293d2323112b4cca6&q=\(searchTerm)&image_type=photo")!
    self.client.fetch(url, decodingType: ImagesAPIResponse.self, completion: {
      switch $0 {
      case .success(let response): completion(.success(response.hits))
      case .failure(let error): completion(.failure(error))
      }
    })
  }

  func download(url: URL, completion: @escaping FileDownloadCompletionHandler) {
    self.client.download(url: url) { (result) in
      switch result {
      case .success(let data): completion(data)
      default: completion(nil)
      }
    }
  }
}
