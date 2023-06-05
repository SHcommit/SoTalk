//
//  LoginViewModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit
import Combine

final class LoginViewModel {
  // MARK: - Properties
  private let loginRepository = LoginRepositoryImpl()
  private var loginModel = LoginModel()
  @Published private var isLoginSuccess = false
}

// MARK: - ViewModelCase
extension LoginViewModel: ViewModelCase {
  func transform(_ input: Input) -> Output {
    return Publishers
      .MergeMany([
        checkLoginSuccess(),
        signUpStream(with: input),
        signInStream(with: input),
        idAndPasswordValidationStream(with: input),
        validateIdInputLengthStream(with: input),
        validatePwInputLengthStream(with: input)])
      .eraseToAnyPublisher()
  }
}

// MARK: - Input operator chain Flow
private extension LoginViewModel {
  func checkLoginSuccess() -> Output {
    return $isLoginSuccess
      .receive(on: DispatchQueue.main)
      .setFailureType(to: ErrorType.self)
      .tryMap { res -> State in
        // 유저 기록TODO: - 여기서 쳇 페이지 가기 전에 로그인 성공하면!! 다시 로그인 유저 기록 가져와야함.
        // 그리고 keychain에 저장.
        return res ? .gotoChatPage : .failedLogin
      }
      .mapError { $0 as? ErrorType ?? .unexpectedError }
      .eraseToAnyPublisher()
  }
  
  func signUpStream(with input: Input) -> Output {
    return input
      .signUp
      .tryMap { _ -> State in return .gotoSignUp }
      .mapError { $0 as? ErrorType ?? .unexpectedError }
      .eraseToAnyPublisher()
  }
  
  func signInStream(with input: Input) -> Output {
    return input
      .signIn
      .setFailureType(to: ErrorType.self)
      .tryMap { [weak self] _ -> State in
        self?.login { [weak self] state in
          self?.isLoginSuccess = state
        }
        return .none }
      .mapError { $0 as? ErrorType ?? .unexpectedError }
      .eraseToAnyPublisher()
  }

  func idAndPasswordValidationStream(with input: Input) -> Output {
    return input
      .idTextFieldChanged
      .combineLatest(input.pwTextFieldChanged)
      .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
      .map {[weak self] id, pw -> State in
        if (1...8).contains(id.count) && (1...16).contains(pw.count) {
          self?.loginModel.id = id
          self?.loginModel.password = pw
          return .idAndPwInputGood
        }
        return .idAndPwInputNotGood
      }
      .setFailureType(to: ErrorType.self)
      .eraseToAnyPublisher()

  }
  
  func validateIdInputLengthStream(with input: Input) -> Output {
    input
      .idTextFieldChanged
      .map { id -> State in
        if (1...8).contains(id.count) {
          return .idInputGood
        }
        return .idInputLengthExcess
      }
      .setFailureType(to: ErrorType.self)
      .eraseToAnyPublisher()
  }
  
  func validatePwInputLengthStream(with input: Input) -> Output {
    input
      .pwTextFieldChanged
      .map { pw -> State in
        if (1...16).contains(pw.count) {
          return .pwInputGood
        }
        return .pwInputLengthExcess
      }
      .setFailureType(to: ErrorType.self)
      .eraseToAnyPublisher()
  }
}

// MARK: - LoginRepositoryImpl
extension LoginViewModel {
  func login(completionHandler: @escaping (Bool) -> Void) {
    guard loginModel.isValidAllValues else {
      print("DEBUG: values' not available :(")
      return
    }
    let requestDTO = LoginRequestDTO(
      id: loginModel.id,
      password: loginModel.password)
    loginRepository.login(requestDTO) { [weak self] userId in
      guard userId == self?.loginModel.id else {
        completionHandler(false)
        return
      }
      completionHandler(true)
    }
  }
}
