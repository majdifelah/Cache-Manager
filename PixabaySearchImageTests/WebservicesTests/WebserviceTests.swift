//
//  WebserviceTests.swift
//  PixabaySearchImageTests
//
//  Created by Majdi Felah on 16/04/20.
//  Copyright © 2020 Majdi Felah. All rights reserved.
//

import XCTest
@testable import PixabaySearchImage

class WebserviceTests: XCTestCase {

  var sut: Webservice!
  private let mockClient = NetworkClientMock()

  override func setUpWithError() throws {
    self.sut = Webservice(client: self.mockClient)
  }

  override func tearDownWithError() throws {
    self.sut = nil
  }

  func test_WhenGetResultsIsCalled_ThenItReturnsResults() {
    // given
    self.mockClient.shouldReturnResults = true
    let searchTerm = "Lion"
    let exp = self.expectation(description: "Waiting for API response")

    // when
    self.sut.getResults(for: searchTerm) { (result) in
      // then
      switch result {
      case .success(let images): XCTAssertEqual(images.count, 4)
      default: XCTFail()
      }
      exp.fulfill()
    }

    self.waitForExpectations(timeout: 1, handler: nil)
  }

  func test_WhenGetResultsIsCalled_ThenItReturnsErrors() {
    // given
    self.mockClient.shouldReturnResults = false
    let searchTerm = "Lion"
    let exp = self.expectation(description: "Waiting for API response")

    // when
    self.sut.getResults(for: searchTerm) { (result) in
      // then
      switch result {
      case .failure(let error): XCTAssertNotNil(error)
      default: XCTFail()
      }
      exp.fulfill()
    }

    self.waitForExpectations(timeout: 1, handler: nil)
  }

  func test_WhenDownloadIsCalled_ThenItReturnsData() {
    // given
    let imageName = "rose-55e0d34048_640"
    self.mockClient.imageDownloadMockData = self.getImageData(from: imageName, type: "jpg")
    let exp = self.expectation(description: "Waiting for image download")

    // when
    self.sut.download(url: URL(string: "google.com")!) { (data) in
      // then
      XCTAssertNotNil(data)
      exp.fulfill()
    }

    self.waitForExpectations(timeout: 1, handler: nil)
  }

  func test_WhenDownloadIsCalled_ThenItReturnsError() {
    // given
    self.mockClient.imageDownloadMockData = nil
    let exp = self.expectation(description: "Waiting for image download")

    // when
    self.sut.download(url: URL(string: "google.com")!) { (data) in
      // then
      XCTAssertNil(data)
      exp.fulfill()
    }

    self.waitForExpectations(timeout: 1, handler: nil)
  }
}

private class NetworkClientMock: NetworkClient {

  var shouldReturnResults = false
  var imageDownloadMockData: Data?

  override func fetch<DecodableType>(_ url: URL, decodingType: DecodableType.Type, completion: @escaping (Result<DecodableType, NetworkClientError>) -> Void) where DecodableType : Decodable {

    if self.shouldReturnResults {
      let images = [ PBImage(id: 0), PBImage(id: 0), PBImage(id: 0), PBImage(id: 0) ]
      let results = ImagesAPIResponse(hits: images) as! DecodableType
      completion(.success(results))
    } else {
      completion(.failure(.invalidJSON))
    }
  }

  override func download(url: URL, completion: @escaping (Result<Data, NetworkClientError>) -> Void) {
    if let data = self.imageDownloadMockData {
      completion(.success(data))
    } else {
      completion(.failure(.emptyData))
    }
  }
}
