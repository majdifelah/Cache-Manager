//
//  WebserviceProtocol.swift
//  PixabaySearchImage
//
//  Created by Majdi Felah on 16/04/20.
//  Copyright © 2020 Majdi Felah. All rights reserved.
//

import Foundation

protocol URLSessionProtocol {
  typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

  func dataTask(with request: URLRequest,
                completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
  func dataTask(with request: URLRequest,
                completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
    let dataTask = self.dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    return dataTask as URLSessionDataTaskProtocol
  }
}

protocol URLSessionDataTaskProtocol {
  func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol { }

enum NetworkClientError: Error {
  case emptyData
  case invalidJSON
  case invalidURL
  case notAuthorized(String)
  case requestFailed(String)
}
extension NetworkClientError: Equatable { }

protocol WebserviceProtocol {

  typealias FileDownloadCompletionHandler = (Data?) -> Void
  typealias ResultsCompletionHandler = (Result<[PBImage], Error>) -> Void

  /// Queries network to get the results for given searchTerm
  /// - Parameters:
  ///   - searchTerm: searchTerm entered by the user
  ///   - completion: Completion closure when the request has finished with some result or error
  func getResults(for searchTerm: String, completion: @escaping ResultsCompletionHandler)

  func download(url: URL, completion: @escaping FileDownloadCompletionHandler)
}
