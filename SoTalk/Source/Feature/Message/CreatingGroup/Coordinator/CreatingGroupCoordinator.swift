//
//  CreatingGroupCoordinator.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/02.
//

import UIKit
import SHCoordinator

final class CreatingGroupCoordinator: NSObject, FlowCoordinator {
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  let presenter: UINavigationController
  
  var viewController: UIViewController!
  
  init(presenter: UINavigationController) {
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
    // 여기서 데이터!! 가지고 돌아갈 수도 있고!!
    // cell에 추가 or 그냥 닫기!!
    viewController.dismiss(animated: true)
    finish()
  }
  
  func gotoImagePicker<ViewController>(
    _ prevVC: ViewController
  ) where ViewController: UIImagePickerControllerDelegate,
          ViewController: UINavigationControllerDelegate,
          ViewController: UIViewController {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .photoLibrary
    imagePicker.allowsEditing = true
    imagePicker.delegate = prevVC
    prevVC.present(imagePicker, animated: true)
  }
}
