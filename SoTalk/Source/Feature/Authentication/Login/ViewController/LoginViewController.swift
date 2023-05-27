//
//  ViewController.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
  // MARK: - Properteis
  private let vm = LoginViewModel()
  private lazy var input = Input(
    idTextFieldChanged: idTextField.changed,
    pwTextFieldChanged: pwTextField.changed,
    signIn: signInChain())
  
  private var subscription = Set<AnyCancellable>()

  private let appName: UILabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = UIFont.boldSystemFont(ofSize: Constant.AppName.textSize)
    $0.numberOfLines = 1
    $0.text = "SoTalk"
    $0.textAlignment = .center
  }
  
  private let idTextField = AuthenticationTextField(with: "아이디")

  private let pwTextField = AuthenticationTextField(with: "비밀번호")
  
  private let signIn = UIButton().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setAttributedTitle(
      NSMutableAttributedString(
        string: "로그인",
        attributes: [
          NSAttributedString.Key.kern: -0.41]),
        for: .normal)
    $0.backgroundColor = Constant.SignIn.bgColor
    $0.layer.cornerRadius = Constant.SignIn.cornerRadius
    $0.setTitleColor(.white, for: .normal)
    $0.isUserInteractionEnabled = false
  }
  
  private let forgetView = ForgetView()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    forgetView.delegate = self
    setupBackgroundBlur()
    setupUI()
    configureUI()
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    input.appear.send()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    guard let touch = touches.first else { return }
    let touchLocation = touch.location(in: self.view)
    if !idTextField.frame.contains(touchLocation) {
      idTextField.hideKeyboard()
    }
    if !pwTextField.frame.contains(touchLocation) {
      pwTextField.hideKeyboard()
    }
  }
  
  private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private helpers
private extension LoginViewController {
  func configureUI() {
    view.backgroundColor = .white
    idTextFieldConfigure()
    pwTextFieldConfigure()
    forgetView.setForgetPlaceHolderColor(.darkGray)
  }
  
  func idTextFieldConfigure() {
    idTextField.setWhiteAndShadow()
    // idTextField.setInputAccessory(with: )
  }
  
  func pwTextFieldConfigure() {
    pwTextField.setWhiteAndShadow()
    // 추후에 ㄱㄱ
    // pwTextField.setInputAccessory(with: )
  }
  
  func signInChain() -> AnyPublisher<Void, Never> {
    signIn
      .tap
      .subscribe(on: RunLoop.main)
      .map {
        UIView.touchAnimate(self.signIn)
      }
      .eraseToAnyPublisher()
  }
  
  @MainActor
  func setSignInNotWorking() {
    signIn.backgroundColor = .Palette.primaryHalf
    signIn.isUserInteractionEnabled = false
  }
  
  @MainActor
  func setSignInWorking() {
    if !(signIn.backgroundColor == .Palette.primary) {
      UIView.touchAnimate(signIn, scale: 0.96)
      signIn.backgroundColor = .Palette.primary
    }
    signIn.isUserInteractionEnabled = true
  }
}

// MARK: - ForgetViewDelegate
extension LoginViewController: ForgetViewDelegate {
  func didTapForgetView() {
    UIView.touchAnimate(forgetView.forgetView, duration: 0.2, scale: 0.75)
    input.signUp.send()
  }
}

// MARK: - ViewBindCase
extension LoginViewController: ViewBindCase {
  typealias Input = LoginViewModel.Input
  typealias ErrorType = LoginViewModel.ErrorType
  typealias State = LoginViewModel.State
  
  func bind() {
    let output = vm.transform(input)
    output.sink { [weak self] completion in
      switch completion {
      case .finished: break
      case .failure(let error):
        self?.handleError(error)
      }
    } receiveValue: { [weak self] in
      self?.render($0)
    }.store(in: &subscription)

  }
  
  func render(_ state: State) {
    switch state {
    case .none:
      print("none")
    case .appear:
      print("appear")
    case .gotoSignUp:
      navigationController?
        .pushViewController(SignUpViewController(), animated: true)
    case .gotoChatPage:
      print("goto chat page")
    case .idInputLengthExcess:
      idTextField.setValidState(.inputExcess)
      setSignInNotWorking()
    case .pwInputLengthExcess:
      pwTextField.setValidState(.inputExcess)
      setSignInNotWorking()
    case .idInputGood:
      idTextField.setValidState(.editing)
    case .pwInputGood:
      pwTextField.setValidState(.editing)
    case .idAndPwInputNotGood:
      setSignInNotWorking()
    case .idAndPwInputGood:
      setSignInWorking()
    }
  }
  
  func handleError(_ error: LoginViewModel.ErrorType) {
    switch error {
    case .none:
      print("none")
    case .unexpectedError:
      print("unexpectedError")
    }
  }
}

// MARK: - LayoutSupport
extension LoginViewController: LayoutSupport {
  func addSubviews() {
    _=[appName, idTextField, pwTextField, signIn, forgetView]
      .map { view.addSubview($0) }
  }
  
  func setConstraints() {
    _=[appNameConstraint,
       idTextFieldConstraint,
       pwTextFieldConstraint,
       loginButtonConstraint,
       forgetViewConstraint]
      .map { NSLayoutConstraint.activate($0) }
  }
}

// MARK: - Layout support constraint
extension LoginViewController {
  var appNameConstraint: [NSLayoutConstraint] {
    [appName.topAnchor.constraint(
      equalTo: view.safeAreaLayoutGuide.topAnchor,
      constant: Constant.AppName.spacing.top),
     appName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
     appName.heightAnchor.constraint(
      equalToConstant: Constant.AppName.height)]
  }
  
  var idTextFieldConstraint: [NSLayoutConstraint] {
    [idTextField.topAnchor.constraint(
      equalTo: appName.bottomAnchor,
      constant: Constant.ID.spacing.top),
     idTextField.leadingAnchor.constraint(
      equalTo: view.leadingAnchor,
      constant: Constant.ID.spacing.leading),
     idTextField.trailingAnchor.constraint(
      equalTo: view.trailingAnchor,
      constant: -Constant.ID.spacing.trailing)]
  }
  
  var pwTextFieldConstraint: [NSLayoutConstraint] {
    [pwTextField.topAnchor.constraint(
      equalTo: idTextField.bottomAnchor,
      constant: Constant.PW.spacing.top),
     pwTextField.leadingAnchor.constraint(
      equalTo: view.leadingAnchor,
      constant: Constant.PW.spacing.leading),
     pwTextField.trailingAnchor.constraint(
      equalTo: view.trailingAnchor,
      constant: -Constant.PW.spacing.trailing)]
  }
  
  var loginButtonConstraint: [NSLayoutConstraint] {
    [signIn.topAnchor.constraint(
      equalTo: pwTextField.bottomAnchor,
      constant: Constant.SignIn.spacing.top),
      signIn.leadingAnchor.constraint(
      equalTo: view.leadingAnchor,
      constant: Constant.SignIn.spacing.leading),
     signIn.heightAnchor.constraint(
      equalToConstant: Constant.SignIn.height),
     signIn.trailingAnchor.constraint(
      equalTo: view.trailingAnchor,
      constant: -Constant.SignIn.spacing.trailing)]
  }
  
  var forgetViewConstraint: [NSLayoutConstraint] {
    [forgetView.topAnchor.constraint(
      equalTo: signIn.bottomAnchor,
      constant: Constant.SignIn.spacing.top),
     forgetView.heightAnchor.constraint(equalToConstant: 14),
     forgetView.centerXAnchor.constraint(
      equalTo: view.centerXAnchor)]
  }
}
