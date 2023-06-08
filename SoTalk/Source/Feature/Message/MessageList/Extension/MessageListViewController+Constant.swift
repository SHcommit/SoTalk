//
//  MessageListViewController+Constant.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/30.
//

import UIKit

extension MessageListViewController {
  enum Constant {
    enum SearchBar {
      static let spacing: UISpacing = .init(leading: 31, top: 18, trailing: 24)
    }
    
    enum MyGroupLabel {
      static let spacing: UISpacing = .init(leading: 31, top: 31)
      static let size: CGFloat = 18
      static let textColor: UIColor = .Palette.primary
    }
    
    enum GroupView {
      static let spacing: UISpacing = .init(top: 0)
    }
    
    enum AddGroupButton {
      static let size: CGSize = CGSize(width: 100, height: 40)
      static let spacing: UISpacing = .init(trailing: 15)
    }
  }
}
