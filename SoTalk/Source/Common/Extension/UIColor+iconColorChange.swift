//
//  UIColor+iconColorChange.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/26.
//

import UIKit

extension UIImage {
  /// 이미지의 색을 변경해야 할 경우 이미지 그래픽 컨텍스트를 사용해서 변경
  /// - Parameter color: UIColor
  /// - Returns: 변경된 이미지 색의 이미지
  func setColor(_ color: UIColor) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
    color.setFill()
    
    let context = UIGraphicsGetCurrentContext()
    context?.translateBy(x: 0, y: self.size.height)
    context?.scaleBy(x: 1.0, y: -1.0)
    context?.setBlendMode(CGBlendMode.normal)
    let rect = CGRect(
      origin: .zero,
      size: CGSize(width: self.size.width,
                   height: self.size.height))
    context?.clip(to: rect, mask: self.cgImage!)
    context?.fill(rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
  }
}
