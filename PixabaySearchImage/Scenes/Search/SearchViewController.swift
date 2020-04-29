//
//  SearchViewController.swift
//  PixabaySearchImage
//
//  Created by Majdi Felah on 16/04/20.
//  Copyright © 2020 Majdi Felah. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {

  enum Segues: String {
    case segueShowResults
  }

  // MARK: - Public

  // MARK: - Private

  var viewModel: SearchViewModel!

  // MARK: - IBOutlets

  @IBOutlet private weak var searchTermTextField: UITextField!

  // MARK: - Life cycle

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.addTextFieldObserver()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.removeTextFieldObserver()
  }

  // MARK: - Button actions

  @IBAction func searchButtonTapped(_ sender: UIButton) {
    guard !self.viewModel.isSearchTermEmpty() else {
      self.searchTermTextField.becomeFirstResponder()
      return
    }

    sender.isEnabled = false
    self.viewModel.getResults { (error) in
      if let error = error {
        let alert = UIAlertController(title: "Error",
                                      message: error.description,
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        return
      }

      self.performSegue(withIdentifier: Segues.segueShowResults.rawValue, sender: nil)

      sender.isEnabled = true
    }
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Segues.segueShowResults.rawValue,
      let vc = segue.destination as? ImagesTableViewController {
      vc.viewModel = ImagesListViewModel(images: self.viewModel.results ?? [])
    }
  }
}

// MARK: - TextField editing changed
extension SearchViewController: UITextFieldDelegate {

  private func addTextFieldObserver() {
    self.searchTermTextField.addTarget(self,
                                       action: #selector(searchTermTextFieldEditingChanged(_:)),
                                       for: .editingChanged)
  }

  private func removeTextFieldObserver() {
    self.searchTermTextField.removeTarget(self,
                                          action: #selector(searchTermTextFieldEditingChanged(_:)),
                                          for: .editingChanged)
  }

  @objc private func searchTermTextFieldEditingChanged(_ textField: UITextField) {
    self.viewModel.searchTerm = textField.text
  }
}
