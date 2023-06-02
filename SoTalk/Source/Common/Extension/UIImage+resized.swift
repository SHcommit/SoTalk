//
//  UIImage+resized.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/02.
//

import UIKit

extension UIImage {
  func resized(to size: CGSize) -> UIImage? {
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { _ in
      draw(in: CGRect(origin: .zero, size: size))
    }
  }
}
