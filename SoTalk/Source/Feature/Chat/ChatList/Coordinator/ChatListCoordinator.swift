//
//  ChatListCoordinator.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/31.
//

import UIKit

final class ChatListCoordinator: NSObject, FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: NavigationControler
  var viewController: UIViewController!
  
  override init() {
    let chatListViewController = ChatListViewController()
    presenter = NavigationControler(rootViewController: chatListViewController)
    viewController = chatListViewController
    super.init()
    chatListViewController.coordinator = self
  }
  
  func start() {
    presenter.viewControllers = [viewController]
  }
  
  func finish() {
    guard let parent = parent as? ApplicationFlowCoordinator else { return }
    removeSelf(from: parent)
  }
}

extension ChatListCoordinator {
  func gotoLoginPage() {
    guard let parent = parent as? ApplicationFlowCoordinator else { return }
    parent.gotoLoginPage(withDelete: self)
  }
  
  func gotoChattingPage() {
    let child = MessageCoordinator(presenter: presenter)
    addChild(with: child)
  }
}
