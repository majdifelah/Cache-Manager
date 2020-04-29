//
//  SceneDelegate.swift
//  PixabaySearchImage
//
//  Created by Majdi Felah on 16/04/20.
//  Copyright © 2020 Majdi Felah. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let _ = (scene as? UIWindowScene) else { return }

    if let navigationVC = self.window?.rootViewController as? UINavigationController,
      let searchVC = navigationVC.viewControllers.first as? SearchViewController {
      searchVC.viewModel = SearchViewModel()
    }
  }
}
