//
//  ForgetView.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit

final class ForgetView: UIView {
  // MARK: - Initialization
  let forgetPlaceholderLabel: UILabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 1
    $0.text = "Don't have an account? "
    $0.font = .systemFont(ofSize: Constant.textSize)
    $0.textColor = Constant.ForgetPlaceholderLabel.textColor
  }
  
  lazy var forgetView = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.isUserInteractionEnabled = true
    $0.numberOfLines = 1
    $0.text = "SignUp."
    $0.font = .boldSystemFont(ofSize: Constant.textSize)
    $0.textColor = Constant.ForgetView.normalTextColor
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(didTapForget))
    $0.addGestureRecognizer(tapGesture)
  }
  
  var delegate: ForgetViewDelegate?
  
  // MARK: - Initialization
  private override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
}

// MARK: - Action
extension ForgetView {
  @objc func didTapForget() {
    delegate?.didTapForgetView()
    print("DEBUG: 비번 잊어먹었대")
  }
}

// MARK: - Helpers
extension ForgetView {
  @MainActor
  func setForgetPlaceHolderColor(_ color: UIColor) {
    forgetPlaceholderLabel.textColor = color
  }
}

// MARK: - LayoutSupport
extension ForgetView: LayoutSupport {
  func addSubviews() {
    _=[forgetPlaceholderLabel,
       forgetView]
      .map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[forgetPlaceholderLabelConstraint, forgetViewConstraint]
      .map { NSLayoutConstraint.activate($0) }
  }
}

// MARK: - Layout support constraint
extension ForgetView {
  var forgetPlaceholderLabelConstraint: [NSLayoutConstraint] {
    [forgetPlaceholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
     forgetPlaceholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)]
  }
  
  var forgetViewConstraint: [NSLayoutConstraint] {
    [forgetView.leadingAnchor.constraint(
      equalTo: forgetPlaceholderLabel.trailingAnchor),
     forgetView.trailingAnchor.constraint(equalTo: trailingAnchor),
     forgetView.centerYAnchor.constraint(equalTo: centerYAnchor)]
  }
}
