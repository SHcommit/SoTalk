//
//  ChatListCoordinator.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/31.
//

import UIKit

final class MessageListCoordinator: NSObject, FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: NavigationControler
  var viewController: UIViewController!
  
  override init() {
    let chatListViewController = MessageListViewController()
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

extension MessageListCoordinator {
  func gotoLoginPage() {
    AppSetting[.isLoggedIn] = false
    AppSetting.delete(.userInfo)
    
    guard let parent = parent as? ApplicationFlowCoordinator else { return }
    parent.gotoLoginPage(withDelete: self)
  }
  
  func gotoChattingPage() {
    let child = MessageCoordinator(presenter: presenter)
    addChild(with: child)
  }
  
  func gotoCreatingGroupPage() {
    let child = CreatingGroupCoordinator(presenter: presenter)
    addChild(with: child)
    guard
      let vc = child.viewController as? CreatingGroupBottomSheetViewController,
    let currentVC = viewController as? MessageListViewController else {
      return
    }
    vc.delegate = currentVC
  }
  
  // MARK: - Event has occured from side menu
  func gotoEditProfilePage(
    _ completionHandler: @escaping ((_ state: SideMenuProfileEditState) -> Void)
  ) {
    let editingProfileAlert = EditingProfileAlertController()
    editingProfileAlert.setAlertAction()
    editingProfileAlert.completionHandler = { state in
      completionHandler(state)
    }
    presenter.present(editingProfileAlert, animated: true)
  }
  
  func gotoProfileEditPage<ViewController>(
    with prevVC: ViewController
  ) where ViewController: UIImagePickerControllerDelegate,
          ViewController: UINavigationControllerDelegate,
          ViewController: UIViewController {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .photoLibrary
    imagePicker.allowsEditing = true
    imagePicker.delegate = prevVC
    prevVC.present(imagePicker, animated: true)
  }
  
  func gotoBuyMeACoffeePage() {
    
  }
  
  func gotoAboutUsPage() {
    
  }
}
