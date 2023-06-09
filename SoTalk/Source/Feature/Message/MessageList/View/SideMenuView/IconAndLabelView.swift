//
//  IconAndLabelView.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/08.
//

import UIKit

final class IconAndLabelView: UIView {
  // MARK: - Properties
  private let icon = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFill
  }
  
  private let label = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .boldSystemFont(ofSize: 20)
    $0.textColor = .Palette.primary
    
    $0.numberOfLines = 1
    $0.text = "menu"
    $0.sizeToFit()
  }
  
  // MARK: - Lifecycle
  private override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .white
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
}

// MARK: - Helper
extension IconAndLabelView {
  @MainActor
  func configure(with text: String, _ image: UIImage) {
    label.text = text
    self.icon.image = image
  }
}

// MARK: - LayoutSupport
extension IconAndLabelView: LayoutSupport {
  func addSubviews() {
    _=[icon, label].map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[iconConstraints, labelConstraints].map { NSLayoutConstraint.activate($0) }
  }
}

// MARK: - LayoutSupport helper
private extension IconAndLabelView {
  var iconConstraints: [NSLayoutConstraint] {
    [icon.widthAnchor.constraint(equalToConstant: label.bounds.height),
     icon.heightAnchor.constraint(equalToConstant: label.bounds.height),
     icon.leadingAnchor.constraint(equalTo: leadingAnchor),
     icon.centerYAnchor.constraint(equalTo: centerYAnchor)]
  }
  
  var labelConstraints: [NSLayoutConstraint] {
    [label.leadingAnchor.constraint(
      equalTo: icon.trailingAnchor,
    constant: 20),
     label.centerYAnchor.constraint(equalTo: centerYAnchor),
     label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)]
  }
}
