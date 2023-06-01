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
    $0.textColor = .black
    $0.numberOfLines = 1
  }
  
  private let messageLabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .systemFont(ofSize: Constant.NameLabel.fontSize)
    $0.text = "빈 텍스트"
    $0.textColor = .black
    $0.numberOfLines = 0
    $0.textAlignment = .natural
  }
  
  private var messageLabelTopConstraint: NSLayoutConstraint?
  
  // MARK: - Lifecycle
  private override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = 7
    let randColor: UIColor = .ChatPalette.randColor
    backgroundColor = randColor
    layer.shadowOffset = CGSize(width: 0, height: 1)
    layer.shadowColor = randColor.cgColor
    layer.shadowOpacity = 1
    layer.shadowRadius = 9
    
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
      guard var messageLabelTopConstraint = messageLabelTopConstraint else { return }
      messageLabelTopConstraint.isActive = false
      messageLabelTopConstraint = messageLabel.topAnchor.constraint(
        equalTo: topAnchor,
        constant: Constant.MessageLabel.spacing.top)
      messageLabelTopConstraint.isActive = true
      nameLabel.isHidden = true
    case .other:
      break
    }
  }
  
  func setNameLabel(with userName: String) {
    nameLabel.text = userName
    nameLabel.sizeToFit()
    nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.bounds.height).isActive = true
  }
  
  func setMessageLabel(with message: String) {
    messageLabel.text = message
    messageLabel.sizeToFit()
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
      constant: Constant.NameLabel.spacing.top),
     nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)]
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
