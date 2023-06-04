//
//  BottomNaviBar+Constant.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import UIKit

extension BottomNaviBar {
  // MARK: - Constant
  enum Constant {
    static let width: CGFloat = UIScreen.main.bounds.width
    
    static let cornerRadius: CGFloat = 32.73
    
    static let shadowOpacity: Float = 1
    
    static let shadowOffset: CGSize = CGSize(width: 0, height: 10.91)
    
    static let shadowRadius: CGFloat = 4.0
    
    static let shadowColor: CGColor = UIColor(
      red: 0.251, green: 0.157, blue: 0.404, alpha: 0.05).cgColor
    
    enum MainTitle {
      static let fontSize: CGFloat = 30.0
      static let spacing: UISpacing = .init(leading: 31, top: 42)
    }
    
    enum SearchBar {
      static let spacing: UISpacing = .init(
        leading: 32, top: 34, trailing: 32, bottom: 27)
      
      static let size = {
        let height = 42.0
        let width = UIScreen.main.bounds.width - 25*2.0
        return CGSize(width: width, height: height)
      }()
    }
    
  }
}
