//
//  ImagesTableViewController.swift
//  PixabaySearchImage
//
//  Created by Majdi Felah on 16/04/20.
//  Copyright © 2020 Majdi Felah. All rights reserved.
//

import UIKit

class ImagesTableViewController: UITableViewController {

  private enum Constants {
    static let reuseId = "ImageTableViewCell"
  }

  var viewModel: ImagesListViewModel!
}

// MARK: - Table view data source
extension ImagesTableViewController {

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.viewModel.count
  }

  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseId, for: indexPath) as! ImageTableViewCell
    cell.set(item: self.viewModel[indexPath.row])
    return cell
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return CGFloat(self.viewModel.height(for: indexPath.row,
                                         containerWidth: Double(tableView.frame.width)))
  }
}

final class ImageTableViewCell: UITableViewCell {

  private var item: ImageViewModel!
  @IBOutlet private weak var itemImageView: UIImageView!

  func set(item: ImageViewModel) {
    self.item = item

    self.itemImageView.image = nil
    item.loadImage { (data, type) in
      DispatchQueue.main.async {
        guard let data = data else {
          self.itemImageView.image = nil
          return
        }
        self.itemImageView.image = UIImage(data: data)
      }
    }
  }
}
