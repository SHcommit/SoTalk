//
//  CreatingGroupCoordinator.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/02.
//

import UIKit

final class CreatingGroupCoordinator: NSObject, FlowCoordinator {
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: NavigationControler
  
  var viewController: UIViewController!
  
  init(presenter: NavigationControler) {
    let creatingGroupBottomSheetViewController = CreatingGroupBottomSheetViewController()
    viewController = creatingGroupBottomSheetViewController
    self.presenter = presenter
    super.init()
    creatingGroupBottomSheetViewController.coordinator = self
  }
  
  func start() {
    let nav = UINavigationController(rootViewController: viewController)
    nav.modalPresentationStyle = .pageSheet
    if let sheet = nav.sheetPresentationController {
      sheet.detents = [.medium()]
    }
    parent.viewController.present(nav, animated: true)
  }
  
  func finish() {
    removeSelf(from: parent)
  }
}

extension CreatingGroupCoordinator {
  func gotoMessageListPage() {
    presenter.popViewController(animated: false)
    finish()
  }
}
