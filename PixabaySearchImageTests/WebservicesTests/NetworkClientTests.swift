//
//  NetworkClientTests.swift
//  PixabaySearchImageTests
//
//  Created by Majdi Felah on 16/04/20.
//  Copyright © 2020 Majdi Felah. All rights reserved.
//

import XCTest
@testable import PixabaySearchImage

class NetworkClientTests: XCTestCase {

  var sut: NetworkClient!

  private func configureSUT(from jsonFile: String? = nil) {
    var mockData: Data?
    if let name = jsonFile { mockData = getDataFromJSON(in: name) }
    let mockSession = URLSessionMock(data: mockData, urlResponse: nil, error: nil)
    self.sut = NetworkClient(session: mockSession)
  }

  override func tearDownWithError() throws {
    self.sut = nil
  }

  func test_WhenFetchIsCalled_ThenItReturnsData() {
    // given
    self.configureSUT(from: "success")
    let exp = self.expectation(description: "Waiting for response")
    let url = URL(string: "google.com")!

    // when
    self.sut.fetch(url, decodingType: ImagesAPIResponse.self) { (result) in
      // then
      switch result {
      case .success(let response): XCTAssertNotNil(response)
      default: XCTFail()
      }
      exp.fulfill()
    }

    self.waitForExpectations(timeout: 1, handler: nil)
  }

  func test_WhenFetchIsCalled_ThenItReturnsError() {
    // given
    self.configureSUT(from: "failure")
    let exp = self.expectation(description: "Waiting for response")
    let url = URL(string: "google.com")!

    // when
    self.sut.fetch(url, decodingType: ImagesAPIResponse.self) { (result) in
      // then
      switch result {
      case .failure(let error): XCTAssertNotNil(error)
      default: XCTFail()
      }
      exp.fulfill()
    }

    self.waitForExpectations(timeout: 1, handler: nil)
  }

  func test_WhenFetchIsCalled_ThenItReturnsEmptyDataError() {
    // given
    self.configureSUT()
    let exp = self.expectation(description: "Waiting for response")
    let url = URL(string: "google.com")!

    // when
    self.sut.fetch(url, decodingType: ImagesAPIResponse.self) { (result) in
      // then
      switch result {
      case .failure(let error):
        XCTAssertNotNil(error)
        XCTAssertEqual(error, NetworkClientError.emptyData)
      default: XCTFail()
      }
      exp.fulfill()
    }

    self.waitForExpectations(timeout: 1, handler: nil)
  }

  func test_WhenDownloadIsCalled_ThenItReturnsData() {
    // given
    let url = URL(string: "google.com")!
    let imageName = "rose-55e0d34048_640"
    let data = self.getImageData(from: imageName, type: "jpg")
    let mockSession = URLSessionMock(data: data, urlResponse: nil, error: nil)
    self.sut = NetworkClient(session: mockSession)
    let exp = self.expectation(description: "Waiting for image download")

    // when
    self.sut.download(url: url) { (result) in
      // then
      switch result {
      case .success(let data): XCTAssertNotNil(data)
      default: XCTFail()
      }
      exp.fulfill()
    }

    self.waitForExpectations(timeout: 1, handler: nil)
  }

  func test_WhenDownloadIsCalled_ThenItReturnsError() {
    // given
    let url = URL(string: "google.com")!
    let mockSession = URLSessionMock(data: nil, urlResponse: nil, error: NetworkClientError.emptyData)
    self.sut = NetworkClient(session: mockSession)
    let exp = self.expectation(description: "Waiting for image download")

    // when
    self.sut.download(url: url) { (result) in
      // then
      switch result {
      case .failure(let error): XCTAssertNotNil(error)
      default: XCTFail()
      }
      exp.fulfill()
    }

    self.waitForExpectations(timeout: 1, handler: nil)
  }
}
