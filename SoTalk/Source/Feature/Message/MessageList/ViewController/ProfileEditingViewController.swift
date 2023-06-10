//
//  ProfileEditingViewController.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/09.
//

import UIKit

final class ProfileEditingViewController: UIViewController {
  // MARK: - Properties
  private var textfield: AuthenticationTextField!

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black.withAlphaComponent(0.3)
  }
  
  private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  convenience init(with state: SideMenuProfileEditState) {
    self.init(nibName: nil, bundle: nil)
    if state != .profile {
      if state == .name {
        textfield = AuthenticationTextField(with: "새 이름을 입력해주세요.")
      } else if state == .nickname {
        textfield = AuthenticationTextField(with: "새 닉네임을 입력해주세요.")
      }
      setupUI()
    }
  }
}

// MARK: - Helper
extension ProfileEditingViewController {
  
}

extension ProfileEditingViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(textfield)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate(textfieldConstraints)
  }
}

private extension ProfileEditingViewController {
  var textfieldConstraints: [NSLayoutConstraint] {
    [textfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
     textfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
     textfield.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
  }
}
