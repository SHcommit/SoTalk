//
//  ChattingTextField.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import UIKit

final class ChattingTextView: UITextView {
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
  
  weak var textDelegate: ChattingTextViewDelegate?
  
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
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UITextViewDelegate
extension ChattingTextView: UITextViewDelegate {
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
extension ChattingTextView: LayoutSupport {
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
