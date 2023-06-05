//
//  LoginViewModel+Transform.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import Combine

extension LoginViewModel: ViewModelAssociatedType {
  struct Input {
    let idTextFieldChanged: AnyPublisher<String, Never>
    let pwTextFieldChanged: AnyPublisher<String, Never>
    let signIn: AnyPublisher<Void, Never>
    let signUp: PassthroughSubject<Void, ErrorType>
    
    init(
      idTextFieldChanged: AnyPublisher<String, Never>,
      pwTextFieldChanged: AnyPublisher<String, Never>,
      signIn: AnyPublisher<Void, Never>,
      signUp: PassthroughSubject<Void, ErrorType> = .init()
    ) {
      self.idTextFieldChanged = idTextFieldChanged
      self.pwTextFieldChanged = pwTextFieldChanged
      self.signIn = signIn
      self.signUp = signUp
    }
  }
  
  enum ErrorType: Error {
    case none
    case unexpectedError
  }
  
  enum State {
    case gotoSignUp
    case gotoChatPage
    case idInputLengthExcess
    case pwInputLengthExcess
    case idInputGood
    case pwInputGood
    case idAndPwInputGood
    case idAndPwInputNotGood
    case failedLogin
    case loginExecuting
    case none
  }
  
  typealias Output = AnyPublisher<State, ErrorType>
}
