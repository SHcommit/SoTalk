//
//  SignUpViewCell+Constant.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/28.
//

import UIKit

extension SignUpViewCell {
  enum Constant {
    enum Title {
      static let textSize: CGFloat = 24
      static let textColor: UIColor = .black
      static let spacing: UISpacing = .init(leading: 27, top: 61)
    }
    
    enum TextField {
      static let spacing: UISpacing = .init(leading: 24, top: 13, trailing: 24)
      static let accessroyViewHeight: CGFloat = 75
    }
    
    enum PasswordRemindTF {
      static let spacing: UISpacing = .init(leading: 24, top: 12, trailing: 24)
    }
    
    enum nextButton {
      static let spacing: UISpacing = .init(leading: 24, top: 0, trailing: -24, bottom: -10)
    }
  }
}
