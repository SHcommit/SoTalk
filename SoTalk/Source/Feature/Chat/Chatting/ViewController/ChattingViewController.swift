//
//  ChatViewController.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import UIKit

final class ChattingViewContrller: UIViewController {
  // MARK: - Properties
  weak var coordinator: ChattingCoordinator?
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .brown
    guard
      let navi = navigationController as? NavigationControler
    else {
      return
    }
    navi.setLeftBackButton(navigationItem, target: self, action: #selector(didTapBackButton))
  }
  
  private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension ChattingViewContrller {
  @objc func didTapBackButton() {
    navigationController?.popViewController(animated: true)
  }
}
