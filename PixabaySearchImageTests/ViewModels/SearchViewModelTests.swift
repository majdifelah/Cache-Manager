//
//  SearchViewModelTests.swift
//  PixabaySearchImageTests
//
//  Created by Majdi Felah on 16/04/20.
//  Copyright © 2020 Majdi Felah. All rights reserved.
//

import XCTest
@testable import PixabaySearchImage

class SearchViewModelTests: XCTestCase {

  var sut: SearchViewModel!

  private let mockService = WebserviceMock()
  private var mockCacheManager = PBImageCacheManagerMock(cacheLimit: 10)

  override func setUpWithError() throws {
    self.sut = SearchViewModel(webservice: self.mockService, cacheManager: self.mockCacheManager)
  }

  override func tearDownWithError() throws {
    self.mockService.results = nil
    self.mockService.error = nil
    self.mockCacheManager.insertCalled = false
    self.mockCacheManager.insertCacheKey = ""
    self.mockCacheManager.items = nil
    self.mockCacheManager.clear()
    self.sut = nil
  }

  func test_WhenSearchTermIsNil_ThenSearchEmptyFunctionReturnsTrue() {
    // given
    self.sut.searchTerm = nil

    // when
    let result = self.sut.isSearchTermEmpty()

    // then
    XCTAssertTrue(result)
  }

  func test_WhenSearchTermIsEmpty_ThenSearchEmptyFunctionReturnsTrue() {
    // given
    self.sut.searchTerm = ""

    // when
    let result = self.sut.isSearchTermEmpty()

    // then
    XCTAssertTrue(result)
  }

  func test_WhenSearchTermContainsOnlySpaces_ThenSearchEmptyFunctionReturnsTrue() {
    // given
    self.sut.searchTerm = "          "

    // when
    let result = self.sut.isSearchTermEmpty()

    // then
    XCTAssertTrue(result)
  }

  func test_WhenSearchTermIsNotEmpty_ThenSearchEmptyFunctionReturnsFalse() {
    // given
    self.sut.searchTerm = "A"

    // when
    let result = self.sut.isSearchTermEmpty()

    // then
    XCTAssertFalse(result)
  }
}

// MARK: - Test Get results API call
extension SearchViewModelTests {

  func test_WhenSearchTermIsEmptyAndGetResultIsCalled_ThenErrorIsReturned() {
    // given
    self.sut.searchTerm = ""
    self.mockService.error = SearchViewModel.SearchError.emptySearchTerm
    let exp = self.expectation(description: "Waiting for API response")

    // when
    self.sut.getResults { (error) in
      // then
      XCTAssertNotNil(error)
      exp.fulfill()
    }

    self.waitForExpectations(timeout: 1, handler: nil)
  }

  func test_WhenSearchTermIsNonEmptyAndGetResultIsCalled_ThenResultsAreFetched() {
    // given
    self.sut.searchTerm = "Lion"
    self.mockService.results = [ PBImage(id: 0), PBImage(id: 0), PBImage(id: 0), PBImage(id: 0) ]
    let exp = self.expectation(description: "Waiting for API response")

    // when
    self.sut.getResults { (error) in
      XCTAssertNil(error)
      exp.fulfill()
    }

    self.waitForExpectations(timeout: 1, handler: nil)

    // then
    XCTAssertEqual(self.sut.results?.count, 4)
  }

  func test_WhenGetResultIsCalledAndNetworkErrorOccurs_ThenErrorIsReturned() {
    // given
    self.sut.searchTerm = "Lion"
    self.mockService.error = NetworkClientError.invalidJSON
    let exp = self.expectation(description: "Waiting for API response")

    // when
    self.sut.getResults { (error) in
      // then
      XCTAssertNotNil(error)
      exp.fulfill()
    }

    self.waitForExpectations(timeout: 1, handler: nil)
  }
}

// MARK: - Test Cache
extension SearchViewModelTests {

  func test_WhenGetResultsIsCalledAndResultsAreAlreadyCached_ThenResultsAreRetrievedFromCache() {
    // given
    self.sut.searchTerm = "Lion"
    self.mockCacheManager.items = [ PBImage(id: 0), PBImage(id: 0), PBImage(id: 0), PBImage(id: 0) ]
    let exp = self.expectation(description: "Waiting for API response")

    // when
    self.sut.getResults { (error) in
      XCTAssertNil(error)
      exp.fulfill()
    }

    self.waitForExpectations(timeout: 1, handler: nil)

    // then
    XCTAssertEqual(self.sut.results?.count, 4)
    XCTAssertFalse(self.mockCacheManager.insertCalled)
  }

  func test_WhenGetResultsIsCalledAndResultsAreRetrieved_ThenResultsAreSavedToCache() {
    // given
    self.sut.searchTerm = "Lion"
    self.mockService.results = [ PBImage(id: 0), PBImage(id: 0), PBImage(id: 0), PBImage(id: 0) ]
    let exp = self.expectation(description: "Waiting for cache")

    // when
    self.sut.getResults { (error) in
      XCTAssertNil(error)
      exp.fulfill()
    }

    self.waitForExpectations(timeout: 1, handler: nil)

    // then
    XCTAssertTrue(self.mockCacheManager.insertCalled)
    XCTAssertEqual(self.mockCacheManager.insertCacheKey, "Lion")
  }
}

private class WebserviceMock: WebserviceProtocol {

  var results: [PBImage]?
  var error: Error?

  func getResults(for searchTerm: String, completion: @escaping ResultsCompletionHandler) {
    if let results = self.results {
      completion(.success(results))
      return
    }

    if let error = error {
      completion(.failure(error))
      return
    }

    fatalError("Error or results expected but found nil")
  }

  func download(url: URL, completion: @escaping FileDownloadCompletionHandler) {
    fatalError()
  }
}

private class PBImageCacheManagerMock: PBImageCacheManager {

  var insertCalled = false
  var insertCacheKey: Key = ""
  var items: [PBImage]?

  override func insert(value: Cachable, for key: PBImageCacheManager.Key) {
    self.insertCalled = true
    self.insertCacheKey = key
  }

  override func getItem<T>(by key: PBImageCacheManager.Key, type: T.Type) -> T? {
    return self.items as? T
  }
}
