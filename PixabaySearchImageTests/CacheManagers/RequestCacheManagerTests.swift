//
//  RequestCacheManagerTests.swift
//  PixabaySearchImageTests
//
//  Created by Majdi Felah on 16/04/20.
//  Copyright © 2020 Majdi Felah. All rights reserved.
//

import XCTest
@testable import PixabaySearchImage

class PBRequestCacheManagerTests: XCTestCase {
    
    var sut: PBImageCacheManager!
    
    override func setUpWithError() throws {
        self.sut = PBMainCacheManager.imageResultsCacheManager
        
    }
    
    override func tearDownWithError() throws {
        self.sut.clear()
        self.sut = nil
    }
    
    func test_WhenCachingRequests_ThenCachesTheRequests() {
        // given
        let results = [ PBImage(id: 0), PBImage(id: 1), PBImage(id: 2), PBImage(id: 3), PBImage(id: 4) ]
        let searchTerm = "Lion"
        
        // when
        self.sut.insert(value: results, for: searchTerm)
        
        // then
        let cachedResults = self.sut.getItem(by: "Lion", type: [PBImage].self)
        XCTAssertEqual(cachedResults?.count, 5)
        XCTAssertEqual(self.sut.cachedItems.count, 1)
    }
    
    func test_WhenCachedRequestsAreOverTheCapacity_ThenItShouldDropOldestCachedRequest() {
        // given
        for index in 0..<10 {
            let results = [PBImage]()
            let searchTerm = "Lion\(index)"
            self.sut.insert(value: results, for: searchTerm)
        }
        
        // when
        let results = [PBImage]()
        
        let searchTerm = "Tiger"
        self.sut.insert(value: results, for: searchTerm)
        
        // then
        let cachedResults = self.sut.getItem(by: "Lion0", type: [PBImage].self)
        XCTAssertNil(cachedResults)
        XCTAssertEqual(self.sut.cachedItems.count, 10)
    }
    
    func test_WhenCachedRequestsAreCleared_ThenCacheIsEmpty() {
        // given
        let results = [ PBImage(id: 0), PBImage(id: 0), PBImage(id: 0), PBImage(id: 0), PBImage(id: 0) ]
        let searchTerm = "Lion"
        self.sut.insert(value: results, for: searchTerm)
        
        // when
        self.sut.clear()
        
        // then
        let cachedResults = self.sut.getItem(by: "Lion", type: [PBImage].self)
        XCTAssertNil(cachedResults)
        
        XCTAssertEqual(self.sut.cachedItems.count, 0)
    }
}
