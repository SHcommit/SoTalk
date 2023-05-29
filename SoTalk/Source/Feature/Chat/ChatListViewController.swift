//
//  ChatListViewController.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/29.
//

import UIKit

extension ChatListViewController {
  enum Constant {
    enum naviTitle {
      static let size: CGFloat = 35
    }
    
    enum MyProfile {
      static let size: CGSize = CGSize(width: 46, height: 46)
    }
    
    enum SearchBar {
      static let spacing: UISpacing = .init(leading: 24, top: 18, trailing: 24)
    }
  }
}

final class ChatListViewController: UIViewController {
  
  let naviTitle = UILabel().set {
    
  }
  
  // MARK: - Lifecycle
  private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(hex: "#F8F8FA")
    navigationController?.navigationBar.backgroundColor = .white
  }
}
