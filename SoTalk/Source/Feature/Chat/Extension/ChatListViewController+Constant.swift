//
//  ChatListViewController+Constant.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/30.
//

import UIKit

extension ChatListViewController {
  enum Constant {
    enum MyProfile {
      static let size: CGSize = CGSize(width: 46, height: 46)
    }
    
    enum SearchBar {
      static let spacing: UISpacing = .init(leading: 31, top: 18, trailing: 24)
    }
    
    enum MyGroupLabel {
      static let spacing: UISpacing = .init(leading: 31, top: 36)
      static let size: CGFloat = 16
      static let textColor: UIColor = .Palette.primary
    }
    
    enum GroupView {
      static let spacing: UISpacing = .init(top: 31)
    }
  }
}
