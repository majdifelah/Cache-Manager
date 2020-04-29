//
//  ImagesListViewModel.swift
//  PixabaySearchImage
//
//  Created by Majdi Felah on 16/04/20.
//  Copyright © 2020 Majdi Felah. All rights reserved.
//

import Foundation

final class ImagesListViewModel {

  var images: [ImageViewModel]
  private let cacheManager: PBImageCacheManager

  init(images: [PBImage], cacheManager: PBImageCacheManager = PBMainCacheManager.imageCacheManager) {
    self.images = images.map({ ImageViewModel(from: $0, cacheManager: cacheManager) })
    self.cacheManager = cacheManager
  }

  subscript(index: Int) -> ImageViewModel { self.images[index] }
  
  var count: Int { self.images.count }

  func height(for index: Int, containerWidth: Double) -> Double {
    let actualHeight = self[index].webformatHeight
    let actualWidth = self[index].webformatWidth
    return containerWidth * actualHeight / actualWidth
  }
}

final class ImageViewModel {

  enum ImageLoadingType {
    case cached
    case downloaded
  }

  private let cacheManager: PBImageCacheManager
  private let webservice: WebserviceProtocol

  let id: Int
  let webformatWidth: Double
  let webformatHeight: Double
  let webformatURL: URL?

  init(from image: PBImage,
       cacheManager: PBImageCacheManager = PBMainCacheManager.imageCacheManager,
       webservice: WebserviceProtocol = Webservice()) {

    self.id = image.id
    self.webformatWidth = image.webformatWidth
    self.webformatHeight = image.webformatHeight
    self.webformatURL = URL(string: image.webformatURL)
    self.cacheManager = cacheManager
    self.webservice = webservice
  }

  func loadImage(_ completion: @escaping (Data?, ImageLoadingType?) -> Void) {
    // 1. Load from cache if found
    if let cachedData = self.cacheManager.getItem(by: "\(self.id)", type: Data.self) {
      completion(cachedData, .cached)
      return
    }

    guard let url = self.webformatURL else {
      completion(nil, nil)
      return
    }

    // 2. Download from Internet
    self.webservice.download(url: url) { data in
      // 3. Cache the image if download was a success
      if let data = data {
        self.cacheManager.insert(value: data, for: "\(self.id)")
      }

      completion(data, .downloaded)
    }
  }
}
