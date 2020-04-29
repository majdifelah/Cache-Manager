//
//  ImagesListViewModelTests.swift
//  PixabaySearchImageTests
//
//  Created by Majdi Felah on 16/04/20.
//  Copyright © 2020 Majdi Felah. All rights reserved.
//

import XCTest
@testable import PixabaySearchImage

class ImagesListViewModelTests: XCTestCase {

  var sut: ImagesListViewModel!
  private var mockCacheManager = PBImageCacheManagerMock(cacheLimit: 10)

  private func configureSUT(images: [PBImage]) {
    self.sut = ImagesListViewModel(images: images, cacheManager: self.mockCacheManager)
  }

  override func tearDownWithError() throws {
    self.sut = nil
  }

  func test_WhenFetchingImageUsingSubscript_ThenReturnsCorrectImage() {
    // given
    self.configureSUT(images: [ PBImage(id: 10), PBImage(id: 11), PBImage(id: 22) ])
    let index = 2

    // when
    let viewModel = self.sut[index]

    // then
    XCTAssertEqual(viewModel.id, 22)
  }

  func test_WhenFetchingImage_ThenReturnsCorrectCount() {
    // given
    self.configureSUT(images: [ PBImage(id: 10), PBImage(id: 11), PBImage(id: 22) ])

    // when
    let count = self.sut.count

    // then
    XCTAssertEqual(count, 3)
  }

  func test_WhenFetchingHeight_ThenReturnsCorrectHeight() {
    // given
    let image = PBImage(id: 10, webformatWidth: 1000, webformatHeight: 500)
    self.configureSUT(images: [ image ])

    // when
    let height = self.sut.height(for: 0, containerWidth: 500)

    // then
    XCTAssertEqual(height, 250)
  }
}

private class PBImageCacheManagerMock: PBImageCacheManager {

  var insertCalled = false
  var insertCacheKey: Key = ""

  override func insert(value: Cachable, for key: PBImageCacheManager.Key) {
    self.insertCalled = true
    self.insertCacheKey = key
  }
}

