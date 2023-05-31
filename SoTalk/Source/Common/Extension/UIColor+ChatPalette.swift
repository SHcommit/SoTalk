//
//  UIColor+ChatPalette.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/30.
//

import UIKit

extension UIColor {
  struct ChatPalette {
    static let count = 13
    
    static var randInt: Int {
      Int.random(in: 0..<count)
    }
    
    private static let colorHexList = [
      "#ffcf8c", "#faf496", "#f8d3df", "#f8a8b4",
      "#f38e7d", "#88bcdc", "#2c8e8f", "#2c8e8f",
      "#90aeca", "#d9e283", "#f66083", "#d9e283",
      "#84694e"]
    
    static let colors: [UIColor] = (0..<count).map {
      UIColor(hex: colorHexList[$0])
    }
  }
}
