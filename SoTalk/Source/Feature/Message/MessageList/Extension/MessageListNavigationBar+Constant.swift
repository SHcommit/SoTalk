//
//  MessageListNavigationBar+Constant.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/30.
//

import Foundation

extension MessageListNavigationBar {
  enum Constant {
    enum BottleView {
      static let size = CGSize(width: 80, height: 80)
      static let imageName = "bottle"
      static let spacing: UISpacing = .init(
        leading: 10)
    }
    enum userNameLabel {
      static let spacing: UISpacing = .init(leading: 0)
      static let fontSize: CGFloat = 16
    }
    enum MyProfile {
      static let size: CGSize = CGSize(width: 40, height: 40)
      static let spacing: UISpacing = .init(trailing: 15)
    }
  }
}
