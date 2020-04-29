//
//  PBRequestCacheManager.swift
//  PixabaySearchImage
//
//  Created by Majdi Felah on 16/04/20.
//  Copyright © 2020 Majdi Felah. All rights reserved.
//

import Foundation
import UIKit

protocol Cachable { }
extension PBImage: Cachable { }
extension Array: Cachable where Element: Cachable { }
extension Data: Cachable { }

fileprivate let RESULTS_LIST_MAX_CACHE_LIMIT = 10
fileprivate let IMAGES_MAX_CACHE_LIMIT = 50

protocol PBCacheManagerProtocol: class {

  typealias Key = String

  /// Maximum number of items which can be cached at a time
  var cacheLimit: Int { get set }

  /// All the cached items
  var cachedItems: [Key: Cachable] { get set }

  /// List of keys of all cached items, to keep the cache retrieval complexity to O(1)
  var keys: [Key] { get set }

  /// Inserts a new item into the cache
  /// - Parameters:
  ///   - value: Object/Item to be cached
  ///   - key: Key to refer the item/object by
  func insert(value: Cachable, for key: Key)

  /// Retrieves a cached item
  /// - Parameter key: The key to lookup the value
  /// - Returns: If the value found it returns the value else nil
  func getItem<T>(by key: Key, type: T.Type) -> T?

  /// Clears the entire cache
  func clear()
}

class PBMainCacheManager {
  static let imageResultsCacheManager = PBImageCacheManager(cacheLimit: RESULTS_LIST_MAX_CACHE_LIMIT)
  static let imageCacheManager = PBImageCacheManager(cacheLimit: IMAGES_MAX_CACHE_LIMIT)
}

class PBImageCacheManager: PBCacheManagerProtocol {

  var cacheLimit: Int
  var cachedItems: [Key: Cachable]
  var keys: [Key]

  init(cacheLimit: Int) {
    self.cacheLimit = cacheLimit
    self.cachedItems = [:]
    self.keys = []
  }

  public func insert(value: Cachable, for key: Key) {
    // Adding key to the cache
    self.keys.append(key)

    self.removeOldCacheItemsIfRequired()

    // Storing the request in to the cache
    self.cachedItems[key] = value
  }

  /// Removes the oldest cached item if the cache is going over the limit
  private func removeOldCacheItemsIfRequired() {
    // Checking if the cache is going over the limit
    if self.isCacheFull(), let key = self.keys.first {
      // If yes, then remove the oldest item from the cache
      self.cachedItems.removeValue(forKey: key)
      self.keys.remove(at: 0)
    }
  }

  /// Checks if the current cache is over the cacheLimit capacity
  /// - Returns: true if the cache is over the capacity, else false
  private func isCacheFull() -> Bool {
    return self.keys.count > self.cacheLimit
  }

  /// Retrieves a cached item
  /// - Parameter key: The key to lookup the value
  /// - Returns: If the value found it returns the value else nil
  public func getItem<T>(by key: Key, type: T.Type) -> T? {
    return self.cachedItems[key] as? T
  }

  /// Clears the entire cache
  public func clear() {
    dump("Clearing out \(self.keys.count) items from cache")
    self.cachedItems = [:]
    self.keys = []
  }
}
