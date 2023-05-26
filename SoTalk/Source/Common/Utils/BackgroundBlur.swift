//
//  BackgroundBlur.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit
extension UIViewController {
  @MainActor
  func setupBackgroundBlur(
    name: String = "loginBackgroundImage"
  ) {
    let iv = UIImageView().set {
      $0.image = UIImage(named: name)
      $0.frame = view.bounds
    }
    let blur = UIBlurEffect(style: .light)
    let bluredView = UIVisualEffectView(effect: blur).set {
      $0.translatesAutoresizingMaskIntoConstraints = false
      $0.frame = iv.bounds
    }
    iv.addSubview(bluredView)
    view.addSubview(iv)
    view.sendSubviewToBack(iv)
  }
}
