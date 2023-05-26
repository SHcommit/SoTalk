//
//  ForgetViewConstant.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit

extension ForgetView {
  enum Constant {
    static let textSize: CGFloat = 12
    enum ForgetPlaceholderLabel {
      static let textColor: UIColor = .Palette.placeHolderGray
    }
    enum ForgetView {
      static let normalTextColor: UIColor = .Palette.primary
      static let highlightTextColor: UIColor = .Palette.primary.withAlphaComponent(0.5)
    }
  }
}
