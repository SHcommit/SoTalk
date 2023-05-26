//
//  AuthenticationTextField.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit
import Combine

final class AuthenticationTextField: UIView {
  typealias ColorState = AuthenticationTextFieldColorState
  
  // MARK: - Properties
  private let textField = UITextField().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = ""
    $0.textColor = .black
    $0.font = UIFont.systemFont(ofSize: Constant.textSize)
    $0.sizeToFit()
  }
  
  var changed: AnyPublisher<String, Never> {
    textField.changed
  }
  
  var heightConstraint: NSLayoutConstraint!
  
  // MARK: - Properties
  private override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = Constant.radius
    setBorderColor(.notEditing)
    layer.borderWidth = 1
    layer.borderColor = UIColor.Palette.grayLine.cgColor
    textField.delegate = self
    setupUI()
  }
  
  convenience init(with placeholder: String) {
    self.init(frame: .zero)
    textField.placeholder = placeholder
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Public helpers
extension AuthenticationTextField {
  @MainActor
  func setPlaceHolder(_ text: String) {
    textField.placeholder = text
  }
  
  @MainActor
  func setBorderColor(_ state: ColorState) {
    layer.borderColor = state.color.cgColor
  }
  
  func setInputAccessory(with view: UIView) {
    textField.inputAccessoryView = view
  }
  
  func hideKeyboard() {
    textField.resignFirstResponder()
  }
  
  @MainActor
  func setHeight(_ height: CGFloat) {
    heightConstraint.isActive = false
    heightConstraint = heightAnchor.constraint(equalToConstant: height)
    heightConstraint.isActive = true
  }
  
  @MainActor
  func setBackgroundColor(_ color: UIColor) {
    backgroundColor = color
  }
  
  @MainActor
  func hideBorderLine() {
    layer.borderWidth = 0
  }
  
  @MainActor
  func setBorderLine(with width: CGFloat) {
    layer.borderWidth = width
  }
  
  @MainActor
  func setWhiteAndShadow() {
    setBackgroundColor(.white)
    setShadow()
  }
  
  @MainActor
  func setShadow() {
    layer.shadowColor = UIColor.gray.cgColor
    layer.shadowOpacity = 0.2
    layer.shadowOffset = CGSize(width: 0, height: 1)
    layer.shadowRadius = 7
  }
}

// MARK: - UITextFieldDelegate
extension AuthenticationTextField: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    setBorderColor(.editing)
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    setBorderColor(.notEditing)
    textField.resignFirstResponder()
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    setBorderColor(.notEditing)
    textField.resignFirstResponder()
    return true
  }
}

// MARK: - LayoutSupport
extension AuthenticationTextField: LayoutSupport {
  func addSubviews() {
    addSubview(textField)
  }
  
  func setConstraints() {
    heightConstraint = heightAnchor.constraint(equalToConstant: 55)
    NSLayoutConstraint.activate([
      heightConstraint,
      textField.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: Constant.spacing.leading),
      textField.trailingAnchor.constraint(
        equalTo: trailingAnchor,
        constant: -Constant.spacing.trailing),
      textField.centerYAnchor.constraint(equalTo: centerYAnchor)])
  }
}
