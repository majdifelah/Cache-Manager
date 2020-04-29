//
//  PBImage.swift
//  PixabaySearchImage
//
//  Created by Majdi Felah on 16/04/20.
//  Copyright © 2020 Majdi Felah. All rights reserved.
//

import Foundation

struct PBImage {
  var id: Int
  let webformatWidth: Double
  let webformatHeight: Double
  let webformatURL: String

  init(id: Int,
       webformatWidth: Double = 0,
       webformatHeight: Double = 0,
       webformatURL: String = "") {

    self.id = id
    self.webformatWidth = webformatWidth
    self.webformatHeight = webformatHeight
    self.webformatURL = webformatURL
  }
}

extension PBImage: Decodable { }
extension PBImage: Equatable { }
