//
//  MessageSendBarInputTextView.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import UIKit
// 카카오톡TODO: - 카카오톡은 아마 텍스트필드에 스크롤 뷰를 달았나본데?,, 나중ㅇ ㅔ 시도해보자
final class MessageSendBarInputTextView: UITextView {
  // MARK: - Properties
  private let placeholderLabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = "메시지를 입력해주세요.."
    $0.font = .systemFont(ofSize: 15)
    $0.textColor = .Palette.primaryHalf
  }
  
  var placeholder: String {
    get {
      placeholderLabel.text ?? ""
    }
    set {
      placeholderLabel.text = newValue
    }
  }
  
  weak var textDelegate: MessageTextViewDelegate?
  
  // MARK: - Lifecycle
  
  override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    delegate = self
    translatesAutoresizingMaskIntoConstraints = false
    font = .systemFont(ofSize: 15)
    isScrollEnabled = false

    backgroundColor = .Palette.searchBG
    layer.cornerRadius = 7
    
    setupUI()
    
    guard let textContainer = textContainer else {
      return
    }
    textContainer.maximumNumberOfLines = 3
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UITextViewDelegate
extension MessageSendBarInputTextView: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    guard !textView.text.isEmpty else {
      placeholderLabel.isHidden = false
      textDelegate?.changed(text: textView.text)
      return
    }
    placeholderLabel.isHidden = true
    textDelegate?.changed(text: textView.text)
  }
}

// MARK: - LayoutSupport
extension MessageSendBarInputTextView: LayoutSupport {
  func addSubviews() {
    addSubview(placeholderLabel)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      placeholderLabel.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: 8),
      placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor)])
  }
}
