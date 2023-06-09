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
  
  // MARK: - Lifecycle
  private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}

// MARK: - Private helper
extension EditingProfileAlertController {
  func setAlertAction() {
    let profile = UIAlertAction(
      title: "프로필 이미지 변경", style: .default
    ) { _ in
      self.completionHandler?(.profile)
    }
    
    let nickname = UIAlertAction(
      title: "닉네임 변경", style: .default
    ) { _ in
      self.completionHandler?(.nickname)
    }
    
    let name = UIAlertAction(
      title: "이름 변경", style: .default
    ) { _ in
      self.completionHandler?(.name)
    }
    
    let cancel = UIAlertAction(
      title: "취소", style: .cancel
    ) { _ in
      self.completionHandler?(.cancel)
    }
    _=[profile, nickname, name, cancel].map {
      addAction($0)
    }
  }
}
