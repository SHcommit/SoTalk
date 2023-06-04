//
//  CreatingGroupBottomSheetViewController+Constant.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/02.
//

import UIKit

extension CreatingGroupBottomSheetViewController {
  enum Constant {
    enum View {
      static let cornerRadius = 35.0
    }
    
    enum GrayBar {
      static let frame = CGRect(
        origin: .init(x: 0, y: 0),
        size: size)
      static let spacing: UISpacing = .init(top: 20)
      static let size = CGSize(width: 80.0, height: 2.5)
      static let radius = 4.0
    }
    
    enum CloseButton {
      static let size = CGSize(width: 22.0, height: 22.0)
    }
    
    enum PictureView {
      static let spacing: UISpacing = .init(top: 12)
      static let size: CGSize = {
        return GroupPictureView.Constant.groupImageView.size
      }()
    }
    
    enum TextField {
      static let spacing: UISpacing = .init(leading: 14, top: 24, trailing: 14)
      static let height = 50.0
      static let textSize = 14.0
    }
    
    enum TextCountPlaceholder {
      static let maximumTextLength = 30
      static let minTextLength = 2
      static let textSize = 12.0
      static let spacing: UISpacing = .init(trailing: 14)
    }
  }
}
