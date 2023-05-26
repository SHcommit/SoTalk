//
//  UISpacing.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import Foundation

struct UISpacing {
  let top: CGFloat
  let leading: CGFloat
  let trailing: CGFloat
  let bottom: CGFloat
  
  init(
    leading: CGFloat = 0,
    top: CGFloat = 0,
    trailing: CGFloat = 0,
    bottom: CGFloat = 0
  ) {
    self.top = top
    self.leading = leading
    self.trailing = trailing
    self.bottom = bottom
  }
}
