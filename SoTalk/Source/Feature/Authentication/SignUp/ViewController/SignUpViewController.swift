//
//  SignupViewController.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit

final class SignUpViewController: UIViewController {
  // MARK: - Properties
  let label = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "hihi"
    $0.font = UIFont.systemFont(ofSize: 14)
  }
  
  // MARK: - Lifecycle
  private override init(
    nibName nibNameOrNil: String?,
    bundle nibBundleOrNil: Bundle?
  ) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupBackgroundBlur()
    setNavigationBar()
    view.addSubview(label)
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)])
  }
}

extension SignUpViewController {
  func setNavigationBar() {
    print("a")
    guard
      let navigationController = navigationController as? NavigationControler else {
      return
    }
    navigationController.setLeftBackButton(navigationItem)
  }
}
