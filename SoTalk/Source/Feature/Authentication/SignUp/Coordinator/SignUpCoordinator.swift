//
//  SignUpCoordinator.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/31.
//

import UIKit
import SHCoordinator

class SignUpCoordinator: NSObject, FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  let presenter: UINavigationController
  var viewController: UIViewController!
  
  // MARK: - Lifecycle
  init(presenter: UINavigationController) {
    self.presenter = presenter
    super.init()
    let vc = SignUpViewController()
    viewController = vc
    vc.coordinator = self
  }
  
  // MARK: - Action
  func start() {
    presenter.pushViewController(viewController, animated: true)
  }
  
  func finish() {
    removeSelf(from: parent)
  }
}

extension SignUpCoordinator {
  func gotoLoginPage() {
    presenter.popViewController(animated: true)
    finish()
  }
}
