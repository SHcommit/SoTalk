//
//  SceneDelegate.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = NavigationControler(rootViewController: LoginViewController())
    window?.makeKeyAndVisible()
  }
}
