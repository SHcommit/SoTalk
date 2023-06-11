//
//  MessageAreaView.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import UIKit

final class MessageContentView: UIView {
  // MARK: - Properties
  let randColor: UIColor = .ChatPalette.randColor
  
  private lazy var nameLabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .boldSystemFont(ofSize: Constant.NameLabel.fontSize)
    $0.text = "익명"
    $0.textColor = .black
    $0.numberOfLines = 1
    $0.textAlignment = .left
    $0.sizeToFit()
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
    backgroundColor = randColor
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  convenience init() {
    self.init(frame: .zero)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.shadowOffset = CGSize(width: 1, height: 1)
    layer.shadowColor = randColor.cgColor
    layer.shadowOpacity = 1
    layer.shadowRadius = 6
    let shadowRect = CGRect(
      x: bounds.origin.x,
      y: bounds.origin.y,
      width: bounds.width,
      height: bounds.height+1)
    layer.shadowPath = UIBezierPath(
      roundedRect: shadowRect,
      cornerRadius: 6).cgPath
  }
}
//
//
//
// 보낸 시간 추가해야함.

// MARK: - Helper
extension MessageContentView {
  func configure(
    with messageContentInfo: MessageContentInfoModel,
    state: MessageSenderState
  ) {
    setMessageLabelTopAnchor(with: state)
    setMessageLabel(with: messageContentInfo.message)
  }
  
  func setNameLabel(with userName: String) {
    DispatchQueue.main.async {
      self.nameLabel.text = userName
      self.nameLabel.sizeToFit()
      self.nameLabel.heightAnchor.constraint(
        equalToConstant: self.nameLabel.bounds.height).isActive = true
    }
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
  
  func setMessageLabel(with message: String) {
    DispatchQueue.main.async {
      self.messageLabel.text = message
      self.messageLabel.sizeToFit()
    }
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
     nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
     nameLabel.heightAnchor.constraint(equalToConstant: nameLabel.bounds.height)]
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
