//
//  LoginViewModel+Transform.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import Combine

extension LoginViewModel: ViewModelAssociatedType {
  struct Input {
    let appear: PassthroughSubject<Void, ErrorType>
    let viewLoad: PassthroughSubject<Void, ErrorType>
    let idTextFieldChanged: AnyPublisher<String, Never>
    let pwTextFieldChanged: AnyPublisher<String, Never>
    let signIn: AnyPublisher<Void, Never>
    let signUp: PassthroughSubject<Void, ErrorType>
    
    init(
      appear: PassthroughSubject<Void, ErrorType> = PassthroughSubject<Void, ErrorType>(),
      viewLoad: PassthroughSubject<Void, ErrorType> = PassthroughSubject<Void, ErrorType>(),
      idTextFieldChanged: AnyPublisher<String, Never>,
      pwTextFieldChanged: AnyPublisher<String, Never>,
      signIn: AnyPublisher<Void, Never>,
      signUp: PassthroughSubject<Void, ErrorType> = PassthroughSubject<Void, ErrorType>()
    ) {
      self.appear = appear
      self.viewLoad = viewLoad
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
    case appear
    case viewLoad
    case gotoSignUp
    case gotoChatPage
    case none
  }
  
  typealias Output = AnyPublisher<State, ErrorType>
}
