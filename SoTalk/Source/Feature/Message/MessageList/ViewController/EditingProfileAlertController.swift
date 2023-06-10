//
//  EditingProfileAlertController.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/09.
//

import UIKit

final class EditingProfileAlertController: UIAlertController {
  // MARK: - Properties
  var completionHandler: ((SideMenuProfileEditState) -> Void)?
  var savedState: SideMenuProfileEditState?
  // MARK: - Lifecycle
  private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
    super.dismiss(animated: flag, completion: completion)
    guard let savedState = savedState else {
      completionHandler?(.cancel)
      return
    }
    completionHandler?(savedState)
  }
}

// MARK: - Private helper
extension EditingProfileAlertController {
  func setAlertAction() {
    let profile = UIAlertAction(
      title: "프로필 이미지 변경", style: .default
    ) { _ in
      // self.completionHandler?(.profile)
      self.savedState = .profile
      self.dismiss(animated: true)
    }
    
    let nickname = UIAlertAction(
      title: "닉네임 변경", style: .default
    ) { _ in
      // self.completionHandler?(.nickname)
      self.savedState = .nickname
      self.dismiss(animated: true)
    }
    
    let name = UIAlertAction(
      title: "이름 변경", style: .default
    ) { _ in
      // self.completionHandler?(.name)
      self.savedState = .name
      self.dismiss(animated: true)
    }
    
    let cancel = UIAlertAction(
      title: "취소", style: .cancel
    ) { _ in
      // self.completionHandler?(.cancel)
      self.savedState = .cancel
      self.dismiss(animated: true)
    }
    _=[profile, nickname, name, cancel].map {
      addAction($0)
    }
  }
}
