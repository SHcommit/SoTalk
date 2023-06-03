//
//  SignUpViewCell.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/28.
//

import UIKit
import Combine

final class SignUpViewCell: UICollectionViewCell {
  // MARK: - Constant
  static let id: String = .init(describing: SignUpViewCell.self)
  typealias InputState = SignUpViewCellInputState
  
  // MARK: - Properties
  private let title: UILabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = UIFont.boldSystemFont(ofSize: Constant.Title.textSize)
    $0.text = ""
    $0.textColor = Constant.Title.textColor
  }
  
  private let nextButton = AuthenticationButton(with: "다음").set {
    $0.isUserInteractionEnabled = false
  }
  
  private lazy var nextButton2 = AuthenticationButton(with: "다음").set {
    $0.isUserInteractionEnabled = false
  }
  
  private var subscription = Set<AnyCancellable>()
  
  weak var delegate: SignUpViewCellDelegate?
  
  private lazy var textField = AuthenticationTextField()
  
  private var passwordRemindTextField: AuthenticationTextField?
  
  private var indexPath: IndexPath?
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    textField.setWhiteAndShadow()
    setNextButtonAccessoryViewFromTextField()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    _=subscription.map { $0.cancel() }
    nextButton.isUserInteractionEnabled = false
    nextButton.setNotWorking()
    textField.text = ""
    passwordRemindTextField = nil
    bind()
  }
}

// MARK: - Helper
extension SignUpViewCell {
  func configure(with text: String, indexPath: IndexPath) {
    setTitle(with: text)
    self.indexPath = indexPath
    switch indexPath.row {
    case InputState.nickname.value:
      textField.setContentType(.name)
    case InputState.name.value:
      textField.setContentType(.name)
    case InputState.password.value:
      textField.setTextSecurityPasswordType()
      createPasswordRe()
    case InputState.signUpEnd.value:
      _=contentView.subviews.map { $0.removeFromSuperview() }
      drawSignUpEndPage()
    default: break
    }
  }
  
  func showKeyboard() {
    textField.showKeyboard()
  }
}

// MARK: - Private helper
private extension SignUpViewCell {
  func setTitle(with text: String) {
    title.text = text
  }
  
  func hideKeyboard() {
    UIApplication.shared.sendAction(
      #selector(UIResponder.resignFirstResponder),
      to: nil,
      from: nil,
      for: nil)
  }
 
  func setNextButtonAccessoryViewFromTextField() {
    textField.setInputAccessoryView(
      with: Constant.TextField.accessroyViewHeight)
    nextButton.setInputAccessoryViewLayout(
      from: textField.accessoryView,
      spacing: Constant.TextField.spacing)
  }
  
  func bind() {
    nextButton.tap.sink { [weak self] _ in
      if (self?.indexPath?.row ?? 0) == InputState.password.value {
        self?.hideKeyboard()
      }
      self?.delegate?.goToNextPage(
        self?.textField.text ?? "",
        currentIndexPath: self?.indexPath ?? IndexPath(row: 0, section: 0))
    }.store(in: &subscription)
    
    textField
      .changed.sink { [weak self] text in
        if (self?.indexPath?.row ?? 0) == SignUpViewCellInputState.password.value {
          guard (2...16).contains(text.count) else {
            self?.textField.setValidState(.inputExcess)
            self?.nextButton.setNotWorking()
            self?.nextButton2.setNotWorking()
            return
          }
          self?.textField.setValidState(.editing)
          return
        }
        guard text.count >= 2 else {
          self?.nextButton.setNotWorking()
          return
        }
        self?.nextButton.setWorking()
      }.store(in: &subscription)
  }
  
  func isPasswordInputPage() -> Bool {
    return (indexPath?.row ?? 0) == InputState.password.value ? true : false
  }
  
  func isSignUpPageEnd() -> Bool {
    return (indexPath?.row ?? 0) == InputState.signUpEnd.value ? true : false
  }
  
  func createPasswordRe() {
    passwordRemindTextField = AuthenticationTextField(
      with: "비밀번호를 다시 입력해주세요.").set {
        $0.setTextSecurityPasswordType()
        $0.setWhiteAndShadow()
        passwordReConstraint($0)
        $0.setInputAccessoryView(with: Constant.TextField.accessroyViewHeight)
        nextButton2.setInputAccessoryViewLayout(
          from: $0.accessoryView,
          spacing: Constant.TextField.spacing)
      }
    
    if (indexPath?.row ?? 0) == InputState.password.value {
      guard let passwordRe = passwordRemindTextField else { return }
      bind(with: passwordRe)
      checkPwAndPwReisEqual(passwordRe)
    }
  }
  
  func bind(with passwordRe: AuthenticationTextField) {
    passwordRe.changed.sink { [weak self] text in
      guard (2...16).contains(text.count) else {
        self?.textField.setValidState(.inputExcess)
        self?.nextButton.setNotWorking()
        self?.nextButton2.setNotWorking()
        return
      }
      self?.textField.setValidState(.editing)
    }.store(in: &subscription)
    
    nextButton2.tap.sink { [weak self] in
      if (self?.indexPath?.row ?? 0) == InputState.password.value {
        self?.hideKeyboard()
      }
      self?.delegate?.goToNextPage(
        self?.textField.text ?? "",
        currentIndexPath: self?.indexPath ?? IndexPath(row: 0, section: 0))
    }.store(in: &subscription)
  }
  
  func checkPwAndPwReisEqual(_ passwordRe: AuthenticationTextField) {
    textField
      .changed
      .combineLatest(passwordRe.changed)
      .sink { [weak self] in
        guard ($0 == $1) && (2...16).contains($0.count) else {
          self?.nextButton.setNotWorking()
          self?.nextButton2.setNotWorking()
          self?.textField.setValidState(.notEditing)
          self?.passwordRemindTextField?.setValidState(.inputExcess)
          return
        }
        self?.passwordRemindTextField?.setValidState(.editing)
        self?.textField.setValidState(.editing)
        self?.nextButton2.setWorking()
        self?.nextButton.setWorking()
      }.store(in: &subscription)
  }
}

// MARK: - LayoutSupport
extension SignUpViewCell: LayoutSupport {
  func addSubviews() {
    _=[title, textField].map { contentView.addSubview($0) }
  }
  
  func setConstraints() {
    _=[titleCosntraint, textFieldConstraint].map { NSLayoutConstraint.activate($0) }
  }
}

// MARK: - Layout support private extension
private extension SignUpViewCell {
  var titleCosntraint: [NSLayoutConstraint] {
    [title.leadingAnchor.constraint(
      equalTo: contentView.leadingAnchor,
      constant: Constant.Title.spacing.leading),
     title.topAnchor.constraint(
      equalTo: contentView.topAnchor,
      constant: Constant.Title.spacing.top)]
  }
  
  var textFieldConstraint: [NSLayoutConstraint] {
    [textField.topAnchor.constraint(
      equalTo: title.bottomAnchor,
      constant: Constant.TextField.spacing.top),
     textField.leadingAnchor.constraint(
      equalTo: contentView.leadingAnchor,
      constant: Constant.TextField.spacing.leading),
     textField.trailingAnchor.constraint(
      equalTo: contentView.trailingAnchor,
      constant: -Constant.TextField.spacing.trailing)]
  }
  
  func passwordReConstraint(_ passwordRe: AuthenticationTextField) {
    contentView.addSubview(passwordRe)
    NSLayoutConstraint.activate([
      passwordRe.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: Constant.PasswordRemindTF.spacing.leading),
      passwordRe.topAnchor.constraint(
        equalTo: textField.bottomAnchor,
        constant: Constant.PasswordRemindTF.spacing.top),
      passwordRe.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor,
        constant: -Constant.PasswordRemindTF.spacing.trailing)
    ])
  }
}
