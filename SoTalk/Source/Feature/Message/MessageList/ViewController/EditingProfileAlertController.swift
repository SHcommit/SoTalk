//
//  EditingProfileAlertController.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/09.
//

import UIKit

final class EditingProfileALertController: UIAlertController {
  
  private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
}

// MARK: - Private helper
extension EditingProfileALertController {
  func setAlertAction() {
    let profile = UIAlertAction(title: "프로필 이미지 변경", style: .default) { action in
      action.isEnabled = false
      self.tapProfile()
    }
    
    let nickname = UIAlertAction(title: "닉네임 변경", style: .default) { action in
      action.isEnabled = false
      self.tapNickname()
    }
    
    let name = UIAlertAction(title: "이름 변경", style: .default) { action in
      action.isEnabled = false
      self.tapName()
    }
    
    let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
      
      self.tapCancel()
    }
    _=[profile, nickname, name, cancel].map {
      addAction($0)
    }
  }
}

// MARK: - Action
extension EditingProfileALertController {
  func tapProfile() {
    print("ok")
  }
  
  func tapNickname() {
    print("aa")
  }
  
  func tapName() {
    print("bbb")
  }
  
  func tapCancel() {
    print("dd")
  }
}
