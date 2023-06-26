//
//  LoginCoordinator.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/31.
//

import UIKit

final class LoginCoordinator: NSObject, FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: NavigationController
  var viewController: UIViewController!
  
  // MARK: - Initialization
  override init() {
    let loginViewController = LoginViewController()
    presenter = NavigationController(rootViewController: loginViewController)
    super.init()
    viewController = loginViewController
    loginViewController.coordinator = self
  }
  
  func start() {
    presenter.viewControllers = [viewController]
  }
  
  func finish() {
    viewController = nil
    removeSelf(from: parent)
  }
}

extension LoginCoordinator {
  func gotoSignUpPage() {
    let childCoordinator = SignUpCoordinator(presenter: presenter)
    addChild(with: childCoordinator)
  }
  
  func gotoChatListPage() {
    guard let parent = parent as? ApplicationFlowCoordinator else {
      print("DEBUG: parent is not applicationFlowCoordinator")
      return
    }
    parent.gotoChatListpage(withDelete: self)
    
  }
}
