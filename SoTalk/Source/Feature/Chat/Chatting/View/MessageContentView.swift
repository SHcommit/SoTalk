//
//  MessageAreaView.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import UIKit

final class MessageContentView: UIView {
  // MARK: - Properties
  private lazy var nameLabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .boldSystemFont(ofSize: Constant.NameLabel.fontSize)
    $0.text = "익명"
    $0.numberOfLines = 1
  }
  
  private let messageLabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .systemFont(ofSize: Constant.NameLabel.fontSize)
    $0.text = "빈 텍스트"
    $0.numberOfLines = 0
  }
  
  private var messageLabelTopConstraint: NSLayoutConstraint?
  
  // MARK: - Lifecycle
  private override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
}

// MARK: - Helper
extension MessageContentView {
  func configure(with data: MessageContentModel, state: MessageSenderState) {
    setMessageLabelTopAnchor(with: state)
    setNameLabel(with: data.name)
    setMessageLabel(with: data.message)
  }
}

// MARK: - Private helper
extension MessageContentView {
  func setMessageLabelTopAnchor(with state: MessageSenderState) {
    switch state {
    case .me:
      messageLabelTopConstraint?.isActive = false
      messageLabelTopConstraint = messageLabel.topAnchor.constraint(
        equalTo: topAnchor,
        constant: Constant.MessageLabel.spacing.top)
      messageLabelTopConstraint?.isActive = true
      nameLabel.isHidden = true
    case .other:
      break
    }
  }
  
  func setNameLabel(with userName: String) {
    nameLabel.text = userName
  }
  
  func setMessageLabel(with message: String) {
    messageLabel.text = message
  }
}

// MARK: - LayoutSupport
extension MessageContentView: LayoutSupport {
  func addSubviews() {
    _=[nameLabel, messageLabel].map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[nameLabelConstraints, messageLabelConstraints].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

private extension MessageContentView {
  var nameLabelConstraints: [NSLayoutConstraint] {
    [nameLabel.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: Constant.NameLabel.spacing.leading),
     nameLabel.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.NameLabel.spacing.top)]
  }
  
  var messageLabelConstraints: [NSLayoutConstraint] {
    let topAnchor = messageLabel.topAnchor.constraint(
      equalTo: nameLabel.bottomAnchor,
      constant: Constant.MessageLabel.spacing.top)
    messageLabelTopConstraint = topAnchor
    return [
      topAnchor,
      messageLabel.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: Constant.MessageLabel.spacing.leading),
      messageLabel.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -Constant.MessageLabel.spacing.trailing),
      messageLabel.bottomAnchor.constraint(
        equalTo: bottomAnchor,
        constant: -Constant.MessageLabel.spacing.bottom)]
  }
}
