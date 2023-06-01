//
//  BackButtonCustomNavigationControler.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/26.
//

import UIKit

class NavigationControler: UINavigationController {
  // MARK: - Propertiese
  var line: OneUnitHeightLine?
  
  private var backButtonImage: UIImage {
    guard let img = UIImage(named: "backButtonImage")?.withRenderingMode(.alwaysOriginal) else {
      return UIImage()
    }
    return img
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
    action: Selector? = #selector(popViewControllerWithAnimated)
  ) {
    let backButton = UIBarButtonItem(
      image: backButtonImage,
      style: .done,
      target: target,
      action: action)
    item.leftBarButtonItem = backButton
  }
  
  func setGrayLineBottom(with color: UIColor) {
    line = OneUnitHeightLine(color: color)
    line?.setConstraint(
      fromSuperView: self.navigationBar,
      spacing: .init(leading: 24, trailing: 24))
  }
  
  func deallocateGrayLineBottom() {
    line?.removeFromSuperview()
  }
}

// MARK: - Action
extension NavigationControler {
  @objc func popViewControllerWithAnimated() {
    popViewController(animated: true)
  }
}
