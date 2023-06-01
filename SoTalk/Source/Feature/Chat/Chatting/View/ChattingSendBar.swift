//
//  CommentSendInputAccessoryView.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import UIKit

final class ChattingSendBar: UIView {
  // MARK: - Constant
  private let sendTitle = "Send"
  
  // MARK: - Properties
  private let textView = ChattingTextView()
  
  private lazy var sendButton: UIButton = UIButton().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .none
    $0.layer.cornerRadius = 4
    $0.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
  }
  
  weak var delegate: CommentSendInputAccessoryViewDelegate?
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    autoresizingMask = .flexibleHeight
    backgroundColor = .white
    textView.textDelegate = self
    setupUI()
    setNotWorkingSendButton()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override var intrinsicContentSize: CGSize {
    .zero
  }
}

// MARK: - Private helper
extension ChattingSendBar {
  func setWorkingSendButton() {
    sendButton.isUserInteractionEnabled = true
    sendButton.backgroundColor = .Palette.primary
    let attributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.boldSystemFont(ofSize: 14),
      .foregroundColor: UIColor.white]
    let attrStr = NSMutableAttributedString(string: sendTitle)
    attrStr.addAttributes(
      attributes,
      range: NSRange(location: 0, length: sendTitle.count))
    sendButton.setAttributedTitle(attrStr, for: .normal)
  }
  
  func setNotWorkingSendButton() {
    sendButton.isUserInteractionEnabled = false
    sendButton.backgroundColor = .none
    let attributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.boldSystemFont(ofSize: 14),
      .foregroundColor: UIColor.Palette.primary]
    let attrStr = NSMutableAttributedString(string: sendTitle)
    attrStr.addAttributes(
      attributes,
      range: NSRange(location: 0, length: sendTitle.count))
    sendButton.setAttributedTitle(attrStr, for: .normal)
  }
}

// MARK: - ChattingTextViewDelegate
extension ChattingSendBar: ChattingTextViewDelegate {
  func changed(text: String) {
    guard !text.isEmpty else {
      setNotWorkingSendButton()
      return
    }
    setWorkingSendButton()
  }
}

// MARK: - Action
extension ChattingSendBar {
  @objc func didTapSend() {
    UIView.animate(
      withDuration: 0.2,
      delay: 0,
      options: .curveEaseOut,
      animations: {
        self.sendButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
      }) { _ in
        UIView.animate(
          withDuration: 0.2) {
            self.sendButton.transform = .identity
          }
      }
    delegate?.inputView(
      wantsToUploadComment: textView.text ?? ""
    ) { [weak self] state in
      switch state {
      case .success:
        self?.textView.text = ""
        self?.setNotWorkingSendButton()
      case .failure:
        print("DEBUG: 네트워크 Send 실패. 신호가 안좋다고 알림 해야함.")
      }
    }
  }
}

// MARK: - LayoutSupport
extension ChattingSendBar: LayoutSupport {
  func addSubviews() {
    _=[textView, sendButton].map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[textViewConstraints, sendButtonConstraints].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

private extension ChattingSendBar {
  var textViewConstraints: [NSLayoutConstraint] {
    [textView.topAnchor.constraint(
      equalTo: topAnchor,
      constant: 8),
     textView.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: 8),
     textView.trailingAnchor.constraint(
      equalTo: sendButton.leadingAnchor,
      constant: -8),
     textView.bottomAnchor.constraint(
      equalTo: safeAreaLayoutGuide.bottomAnchor,
      constant: -8)]
  }
  
  var sendButtonConstraints: [NSLayoutConstraint] {
    
    [sendButton.trailingAnchor.constraint(
      equalTo: trailingAnchor,
      constant: -8),
     sendButton.bottomAnchor.constraint(
      equalTo: safeAreaLayoutGuide.bottomAnchor,
      constant: -8),
     sendButton.widthAnchor.constraint(equalToConstant: 50),
     sendButton.heightAnchor.constraint(equalToConstant: 32)]
  }
}
