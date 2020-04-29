//
//  NetworkClient.swift
//  PixabaySearchImage
//
//  Created by Majdi Felah on 16/04/20.
//  Copyright © 2020 Majdi Felah. All rights reserved.
//

import Foundation

class NetworkClient {

  private let session: URLSessionProtocol

  init(session: URLSessionProtocol = URLSession.shared) {
    self.session = session
  }

  func fetch<DecodableType>(_ url: URL,
                            decodingType: DecodableType.Type,
                            completion: @escaping (Result<DecodableType, NetworkClientError>) -> Void)
    where DecodableType: Decodable {

      let request = URLRequest(url: url)
      let task = self.session.dataTask(with: request) { (data, _, error) in
        guard let data = data else {
          completion(.failure(.emptyData))
          return
        }
        do {
          let decoder = JSONDecoder()
          let decodableModel = try decoder.decode(decodingType, from: data)
          completion(.success(decodableModel))
        } catch {
          print("URL: \(url)")
          print("JSON Conversion failed \(error)")
          completion(.failure(.invalidJSON))
        }
      }
      task.resume()
  }

  func download(url: URL, completion: @escaping (Result<Data, NetworkClientError>) -> Void) {
    let request = URLRequest(url: url)
    let task = self.session.dataTask(with: request) { (data, response, error) in
      guard let data = data else {
        completion(.failure(.requestFailed(error!.localizedDescription)))
        return
      }
      completion(.success(data))
    }
    task.resume()
  }
}
