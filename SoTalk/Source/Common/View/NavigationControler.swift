//
//  BackButtonCustomNavigationControler.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/26.
//

import UIKit

class NavigationControler: UINavigationController {
  // MARK: - Propertiese
  private var backBtnImage: UIImage {
    guard let img = UIImage(named: "backBtn")?.withRenderingMode(.alwaysOriginal) else {
      return UIImage()
    }
    let scaledSize = CGSize(width: 24, height: 24)
    UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
    img.draw(in: CGRect(origin: .zero, size: scaledSize))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return resizedImage?.withTintColor(.black, renderingMode: .alwaysOriginal) ?? UIImage()
  }
  
  // MARK: - Initialization
  override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
  }
  
  convenience init() {
    self.init(rootViewController: UIViewController())
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setLeftBackButton(
    _ item: UINavigationItem,
    target: Any,
    action: Selector
  ) {
    let backButton = UIBarButtonItem(
      image: backBtnImage,
      style: .done,
      target: target,
      action: action)
    item.leftBarButtonItem = backButton
  }
}
