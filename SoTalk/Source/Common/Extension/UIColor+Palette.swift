//
//  UIColor+Palette.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit

extension UIColor {
  enum Palette {
    static let grayLine = UIColor(hex: "#D9D9D9")
    
    static let placeHolderGray = UIColor(hex: "#D9D9D9")
    
    static let edgeLine: UIColor = .black.withAlphaComponent(0.7)
    
    static let primary = UIColor(hex: "#FF9F0A")
    
    static let selectedPrimary = UIColor(hex: "#FFB340")
    
    static let errorRed = UIColor(hex: "#E47A7A")
  }
}
