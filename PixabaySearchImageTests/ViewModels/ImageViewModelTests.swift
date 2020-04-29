//
//  ImageViewModelTests.swift
//  PixabaySearchImageTests
//
//  Created by Majdi Felah on 16/04/20.
//  Copyright © 2020 Majdi Felah. All rights reserved.
//

import XCTest
@testable import PixabaySearchImage

class ImageViewModelTests: XCTestCase {

  var sut: ImageViewModel!
  private let mockService = WebserviceMock()
  private let mockCacheManager = PBImageCacheManagerMock(cacheLimit: 10)

  override func setUpWithError() throws {
    let mockImage = PBImage(id: 11, webformatWidth: 1000, webformatHeight: 2000, webformatURL: "google.com")
    self.sut = ImageViewModel(from: mockImage, cacheManager: self.mockCacheManager, webservice: self.mockService)
  }

  override func tearDownWithError() throws {
    self.sut = nil
    self.mockCacheManager.item = nil
    self.mockService.result = nil
  }
  
  func test_WhenInitialized_ThenHasCorrectValues() {
    // given

    // when

    // then
    XCTAssertEqual(self.sut.id, 11)
    XCTAssertEqual(self.sut.webformatWidth, 1000)
    XCTAssertEqual(self.sut.webformatHeight, 2000)
    XCTAssertNotNil(self.sut.webformatURL)
    XCTAssertEqual(self.sut.webformatURL, URL(string: "google.com"))
  }

  func test_WhenLoadingTheImageAndImageIsNotAvailableInCache_ThenImageIsLoadedFromInternetAndSavedToCache() {
    // given
    let imageName = "rose-55e0d34048_640"
    self.mockService.result = self.getImageData(from: imageName, type: "jpg")
    let exp = self.expectation(description: "Waiting for image download")

    // when
    self.sut.loadImage { (data, type) in
      XCTAssertEqual(type, .downloaded)
      XCTAssertNotNil(data)
      XCTAssertTrue(self.mockCacheManager.insertCalled)
      XCTAssertEqual(self.mockCacheManager.insertCacheKey, "11")
      exp.fulfill()
    }

    // then
    self.waitForExpectations(timeout: 1, handler: nil)
  }

  func test_WhenLoadingTheImageAndImageIsAvailableInCache_ThenImageIsLoadedFromCache() {
    // given
    let imageName = "rose-55e0d34048_640"
    self.mockCacheManager.item = self.getImageData(from: imageName, type: "jpg")
    let exp = self.expectation(description: "Waiting for image cache")

    // when
    self.sut.loadImage { (data, type) in
      XCTAssertEqual(type, .cached)
      XCTAssertNotNil(data)
      exp.fulfill()
    }

    // then
    self.waitForExpectations(timeout: 1, handler: nil)
  }

  func test_WhenLoadingTheImageButImageURLIsNil_ThenReturnsNil() {
    // given
    let mockImage = PBImage(id: 11, webformatWidth: 1000, webformatHeight: 2000, webformatURL: "")
    self.sut = ImageViewModel(from: mockImage, cacheManager: self.mockCacheManager, webservice: self.mockService)
    self.mockCacheManager.item = nil
    let exp = self.expectation(description: "Waiting")

    // when
    self.sut.loadImage { (data, type) in
      XCTAssertNil(type)
      XCTAssertNil(data)
      exp.fulfill()
    }

    // then
    self.waitForExpectations(timeout: 1, handler: nil)
  }
}

private class WebserviceMock: WebserviceProtocol {

  var result: Data?

  func download(url: URL, completion: @escaping FileDownloadCompletionHandler) {
    completion(self.result)
  }

  func getResults(for searchTerm: String, completion: @escaping ResultsCompletionHandler) {
    fatalError()
  }
}

private class PBImageCacheManagerMock: PBImageCacheManager {

  var insertCalled = false
  var insertCacheKey: Key = ""
  var item: Data?

  override func insert(value: Cachable, for key: PBImageCacheManager.Key) {
    self.insertCalled = true
    self.insertCacheKey = key
  }

  override func getItem<T>(by key: PBImageCacheManager.Key, type: T.Type) -> T? {
    return self.item as? T
  }
}
