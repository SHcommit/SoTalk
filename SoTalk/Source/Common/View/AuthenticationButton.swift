//
//  AuthenticationButton.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/28.
//

import UIKit

final class AuthenticationButton: UIButton {
  // MARK: - Constant
  var height: CGFloat = 55
  var spacing = UISpacing()
  let textSize: CGFloat = 14
  let bgColor: UIColor = .Palette.primaryHalf
  let cornerRadius: CGFloat = 8
  let highlightColor: UIColor = .Palette.primary.withAlphaComponent(0.5)
  
  // MARK: - Properties
  weak var accessoryView: UIView?

  // MARK: - Initialization
  private override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init(with title: String) {
    self.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    setAttributedTitle(
      NSMutableAttributedString(
        string: title,
        attributes: [
          NSAttributedString.Key.kern: -0.41]),
      for: .normal)
    backgroundColor = bgColor
    layer.cornerRadius = cornerRadius
    setTitleColor(.white, for: .normal)
    isUserInteractionEnabled = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Public helpers
extension AuthenticationButton {
  @MainActor
  func setNotWorking() {
    backgroundColor = .Palette.primaryHalf
    isUserInteractionEnabled = false
  }
  
  @MainActor
  func setWorking() {
    if !(backgroundColor == .Palette.primary) {
      UIView.touchAnimate(self, scale: 0.96)
      backgroundColor = .Palette.primary
    }
    isUserInteractionEnabled = true
  }
  
  func setInputAccessoryViewLayout(
    from accessoryView: UIView?,
    spacing: UISpacing = .init()) {
      guard let accessoryView = accessoryView else { return }
      accessoryView.addSubview(self)
      self.accessoryView = accessoryView
      self.spacing = spacing
      NSLayoutConstraint.activate([
        leadingAnchor.constraint(
          equalTo: accessoryView.leadingAnchor,
          constant: spacing.leading),
        trailingAnchor.constraint(
          equalTo: accessoryView.trailingAnchor,
          constant: -spacing.trailing),
        heightAnchor.constraint(equalToConstant: height),
        centerYAnchor.constraint(equalTo: accessoryView.centerYAnchor)
      ])
    }
}
