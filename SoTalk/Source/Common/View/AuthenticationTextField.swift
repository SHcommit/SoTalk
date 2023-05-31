//
//  AuthenticationTextField.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit
import Combine

final class AuthenticationTextField: UIView {
  // MARK: - Constant
  typealias ColorState = AuthenticationTextFieldColorState
  
  // MARK: - Properties
  private let textField = UITextField().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.text = ""
    $0.textColor = .black
    $0.font = UIFont.systemFont(ofSize: Constant.textSize)
    $0.sizeToFit()
  }
  
  var text: String {
    get {
      textField.text ?? ""
    }
    set {
      textField.text = newValue
    }
  }
  
  var changed: AnyPublisher<String, Never> {
    textField.changed
  }
  
  @Published private var validState: ColorState = .notEditing
  
  private var subscription = Set<AnyCancellable>()
  
  var accessoryView: UIView?
  
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
    bind()
  }
  
  convenience init(with placeholder: String) {
    self.init(frame: .zero)
    textField.placeholder = placeholder
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    _=subscription.map { $0.cancel() }
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
  
  @MainActor
  func setTextFieldHeight(_ height: CGFloat) {
    heightConstraint.isActive = false
    heightConstraint = heightAnchor.constraint(equalToConstant: height)
    heightConstraint.isActive = true
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
  
  func setContentType(_ type: UITextContentType) {
    textField.textContentType = type
  }
  
  func hideKeyboard() {
    textField.resignFirstResponder()
  }
  
  func showKeyboard() {
    textField.becomeFirstResponder()
  }
  
  func setValidState(
    _ state: AuthenticationTextFieldColorState
  ) {
    validState = state
  }
  
  func setTextSecurityPasswordType() {
    textField.isSecureTextEntry = true
    textField.textContentType = .oneTimeCode
  }
  
  func setInputAccessoryView(with height: CGFloat) {
    accessoryView = UIView(
      frame: CGRect(
        x: 0,
        y: 0,
        width: UIScreen.main.bounds.width,
        height: height)).set {
          $0.translatesAutoresizingMaskIntoConstraints = false
        }
    textField.inputAccessoryView = accessoryView
  }
  
  @MainActor
  func setBackgroundColor(_ color: UIColor) {
    backgroundColor = color
  }
  
  func setNotWorkingAuthCorrectionType() {
    textField.autocorrectionType = .no
  }
  
}

// MARK: - Helpers
private extension AuthenticationTextField {
  func bind() {
    $validState
      .receive(on: DispatchQueue.main)
      .sink {
        self.setBorderColor($0)
      }.store(in: &subscription)
  }
  
  @MainActor
  func setShadow() {
    layer.shadowColor = UIColor.gray.cgColor
    layer.shadowOpacity = 0.2
    layer.shadowOffset = CGSize(width: 0, height: 1)
    layer.shadowRadius = 7
    layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
  }
}

// MARK: - UITextFieldDelegate
extension AuthenticationTextField: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    guard textField.text == "" else {
      setBorderColor(validState)
      return
    }
    validState = .editing
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
