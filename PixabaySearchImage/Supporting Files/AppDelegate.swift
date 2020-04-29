//
//  AppDelegate.swift
//  PixabaySearchImage
//
//  Created by Majdi Felah on 16/04/20.
//  Copyright © 2020 Majdi Felah. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    return true
  }

  func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
    print("Memory pressure. Clearing out the caches")
    PBMainCacheManager.imageResultsCacheManager.clear()
    PBMainCacheManager.imageCacheManager.clear()
  }
}
