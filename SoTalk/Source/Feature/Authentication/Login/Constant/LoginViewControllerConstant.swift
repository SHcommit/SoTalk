//
//  LoginTableViewConstant.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit

extension LoginViewController {
  enum Constant {
    enum AppName {
      static let height: CGFloat = 34
      static let spacing = UISpacing(top: 65)
      static let textSize: CGFloat = 24
    }
    enum ID {
      static let spacing = UISpacing(leading: 24, top: 65, trailing: 24)
    }
    enum PW {
      static let spacing = UISpacing(leading: 24, top: 12, trailing: 24)
    }
    enum SignIn {
      static let height: CGFloat = 55
      static let spacing = UISpacing(leading: 24, top: 12, trailing: 24)
      static let textSize: CGFloat = 14
      static let bgColor: UIColor = .Palette.primaryHalf
      static let cornerRadius: CGFloat = 8
      static let highlightColor: UIColor = .Palette.primary.withAlphaComponent(0.5)
    }
    enum forgetView {
      static let textSize: CGFloat = 12
      static let spacing: UISpacing = .init(top: 15)
    }
  }
}
