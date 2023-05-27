//
//  BackButtonCustomNavigationControler.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/26.
//

import UIKit

class NavigationControler: UINavigationController {
  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private var backButtonImage: UIImage {
    guard let img = UIImage(named: "backButtonImage")?.withRenderingMode(.alwaysOriginal) else {
      return UIImage()
    }
    return img
  }
  
  func setLeftBackButton(_ item: UINavigationItem) {
    let backButton = UIBarButtonItem(
      image: backButtonImage,
      style: .done,
      target: self,
      action: #selector(popViewControllerWithAnimated))
    item.leftBarButtonItem = backButton
  }
}

// MARK: - Action
extension NavigationControler {
  @objc func popViewControllerWithAnimated() {
    popViewController(animated: true)
  }
}
