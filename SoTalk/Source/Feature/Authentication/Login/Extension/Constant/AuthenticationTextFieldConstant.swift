//
//  AuthenticationTextFieldConstant.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit

extension AuthenticationTextField {
  enum Constant {
    static let spacing = UISpacing(leading: 12, top: 11, trailing: 12, bottom: 10)
    static let textSize: CGFloat = 14
    static let radius: CGFloat = 8
    enum EdgeColor {
      static let normal: UIColor = .Palette.edgeLine
      static let correct: UIColor = .Palette.primary
      static let error: UIColor = .Palette.errorRed
    }
  }
}
