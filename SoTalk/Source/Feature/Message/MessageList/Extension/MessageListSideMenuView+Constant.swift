//
//  MessageListSideMenuView+Constant.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/08.
//

import UIKit

extension MessageListSideMenuView {
  enum Constant {
    static let lineSpacing: CGFloat = 60.0
    static let bgColor: UIColor = .Palette.selectedPrimary
    
    enum ProfileView {
      static let spacing: UISpacing = .init(leading: 80, top: 100)
      static let size: CGSize = CGSize(width: 100, height: 100)
    }
    enum Nickname {
      static let spacing: UISpacing = .init(top: 14)
      static let textSize: CGFloat = 20.0
      static let textColor: UIColor = .white
    }
    
    enum Name {
      static let spacing: UISpacing = .init(top: 7)
      static let textSize: CGFloat = 15.0
      static let textColor: UIColor = .white
    }
    
    enum SideMenu {
      static let width: CGFloat = {
        let screen = UIScreen.main.bounds.width
        return screen * 3.0 / 5.0
      }()
      static let spacing: UISpacing = .init(
        top: lineSpacing,
        bottom: {
          var bottomHeight: CGFloat = 0.0
          if #available(iOS 15.0, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let window = windowScene.windows.first
            bottomHeight = window?.safeAreaInsets.bottom ?? 0
            }
          } else if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.first
            bottomHeight = window?.safeAreaInsets.bottom ?? 0
          }
          return bottomHeight + lineSpacing
        }())
    }
  }
}
