//
//  ViewController.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit
import Combine
import Lottie

class LoginViewController: UIViewController {
  // MARK: - Properteis
  private let vm = LoginViewModel()
  private lazy var input = Input(
    idTextFieldChanged: idTextField.changed,
    pwTextFieldChanged: pwTextField.changed,
    signIn: signInChain())
  
  private var subscription = Set<AnyCancellable>()
  
  private let animView: LottieAnimationView = .init(name: "loginMessage").set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFill
    $0.loopMode = .loop
  }

  private let appName: UILabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = UIFont.boldSystemFont(ofSize: Constant.AppName.textSize)
    $0.numberOfLines = 1
    $0.text = "SoTalk"
    $0.textAlignment = .center
  }
  
  private let idTextField = AuthenticationTextField(with: "아이디").set {
    $0.setNotWorkingAuthCorrectionType()
  }

  private let pwTextField = AuthenticationTextField(with: "비밀번호").set {
    $0.setTextSecurityPasswordType()
  }
  
  private let signIn = AuthenticationButton(with: "로그인").set {
    $0.isUserInteractionEnabled = false
  }
  
  private let forgetView = ForgetView()
  
  weak var coordinator: LoginCoordinator?
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    print(AppSetting.getUser())
    forgetView.delegate = self
    setupUI()
    configureUI()
    bind()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(false)
    animView.play()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    animView.stop()
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
  
  deinit {
    print("LoginVC 삭제")
  }
}

// MARK: - Private helpers
private extension LoginViewController {
  func configureUI() {
    view.backgroundColor = .Palette.bgColor
    idTextFieldConfigure()
    pwTextFieldConfigure()
    forgetView.setForgetPlaceHolderColor(.darkGray)
  }
  
  func idTextFieldConfigure() {
    idTextField.setWhiteAndShadow()
  }
  
  func pwTextFieldConfigure() {
    pwTextField.setWhiteAndShadow()
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
      break
    case .gotoSignUp:
      coordinator?.gotoSignUpPage()
    case .gotoChatPage:
      // 인디케이터TODO: - 제거
      idTextField.hideKeyboard()
      pwTextField.hideKeyboard()
      coordinator?.gotoChatListPage()
    case .idInputLengthExcess:
      idTextField.setValidState(.inputExcess)
      signIn.setNotWorking()
    case .pwInputLengthExcess:
      pwTextField.setValidState(.inputExcess)
      signIn.setNotWorking()
    case .idInputGood:
      idTextField.setValidState(.editing)
    case .pwInputGood:
      pwTextField.setValidState(.editing)
    case .idAndPwInputNotGood:
      signIn.setNotWorking()
    case .idAndPwInputGood:
      signIn.setWorking()
    case .failedLogin:
      // 인디케이터TODO: - 제거
      print("DEBUG: 로그인 실패.... 알림창 띄워야함.")
    case .loginExecuting:
      // 인디케이터TODO: - 생성
      print("DEBUG: 로그인 진행중")
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
    _=[appName, animView, idTextField, pwTextField, signIn, forgetView]
      .map { view.addSubview($0) }
  }
  
  func setConstraints() {
    _=[appNameConstraint,
       idTextFieldConstraint,
       pwTextFieldConstraint,
       loginButtonConstraint,
       forgetViewConstraint,
       animViewConstraint]
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
  
  var animViewConstraint: [NSLayoutConstraint] {
    [animView.bottomAnchor.constraint(equalTo: appName.topAnchor),
     animView.leadingAnchor.constraint(
      equalTo: appName.trailingAnchor,
      constant: 10),
     animView.trailingAnchor.constraint(
      equalTo: view.trailingAnchor,
      constant: -24),
     animView.heightAnchor.constraint(equalToConstant: 70)]
  }
}
