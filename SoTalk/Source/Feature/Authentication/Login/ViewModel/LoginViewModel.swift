//
//  LoginViewModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit
import Combine

struct LoginViewModel {
  // MARK: - Properties
}

// MARK: - ViewModelCase
extension LoginViewModel: ViewModelCase {
  func transform(_ input: Input) -> Output {
    return Publishers
      .MergeMany([
        appearStream(with: input),
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
  func appearStream(with input: Input) -> Output {
    return input
      .appear
      .tryMap { return .appear }
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
      .tryMap { _ -> State in return .gotoChatPage }
      .mapError { $0 as? ErrorType ?? .unexpectedError }
      .eraseToAnyPublisher()
  }

  func idAndPasswordValidationStream(with input: Input) -> Output {
    return input
      .idTextFieldChanged
      .combineLatest(input.pwTextFieldChanged)
      .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
      .map { id, pw -> State in
        if (1...8).contains(id.count) && (1...16).contains(pw.count) {
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
