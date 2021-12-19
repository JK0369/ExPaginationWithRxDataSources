//
//  AppDelegate.swift
//  ExPagination
//
//  Created by 김종권 on 2021/12/19.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    let photoViewRacrtor = PhotoViewReactor()
    let photoViewController = PhotoViewController(reactor: photoViewRacrtor)
    let navigationController = UINavigationController(rootViewController: photoViewController)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
    return true
  }
}
