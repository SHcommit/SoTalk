//
//  MessageCoordinator.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import UIKit

class MessageCoordinator: NSObject, FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: NavigationControler
  var viewController: UIViewController!
  
  // MARK: - Lifecycle
  init(presenter: NavigationControler) {
    self.presenter = presenter
    super.init()
    let vc = MessageViewContrller()
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

extension MessageCoordinator {
  func gotoChattingPage() {
    presenter.popViewController(animated: true)
    finish()
  }
}
