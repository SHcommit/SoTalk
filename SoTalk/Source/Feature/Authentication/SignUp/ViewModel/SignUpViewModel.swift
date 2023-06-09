//
//  SignUpViewModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/28.
//

import Foundation

final class SignUpViewModel {
  // MARK: - Properties
  private let data = ["이름을 입력해주세요.", "닉네임을 입력해주세요.", "아이디를 입력해주세요.", "비밀번호를 입력해주세요.", "회원가입 성공"]
  
  private var signUpModel = SignUpModel()
  
  private var signUpRepository = SignUpRepositoryImpl()
}

// MARK: - SignUpViewAdapterDataSource
extension SignUpViewModel: SignUpViewAdapterDataSource {
  var numberOfItems: Int {
    data.count
  }
  
  func cellItem(at index: Int) -> String {
    return data[index]
  } 
}

// MARK: - Public helpers
extension SignUpViewModel {
  func setId(_ text: String) {
    signUpModel.id = text.lowercased()
  }
  
  func setPassword(_ text: String) {
    signUpModel.password = text
  }
  
  func setName(_ text: String) {
    signUpModel.name = text
  }
  
  func setNickname(_ text: String) {
    signUpModel.nickname = text
  }
}

// MARK: - SignUpRepositoryImpl
extension SignUpViewModel {
  func signUp(completionHandler: @escaping (Bool) -> Void) {
    guard signUpModel.isValidValues else {
      print("DEBUG: 잘못된 입력이 있습니다.")
      return
    }
    let requestDTO = SignUpRequestDTO(
      id: signUpModel.id,
      name: signUpModel.name,
      password: signUpModel.password,
      nickname: signUpModel.nickname)
    
    signUpRepository.signUp(requestDTO) { [weak self] userId in
      guard userId == self?.signUpModel.id else {
        completionHandler(false)
        return
      }
      completionHandler(true)
    }
  }
  
  func dulicateCheck(completionHandler: @escaping (Bool) -> Void) {
    guard signUpModel.isIdValidLength else {
      print("DEBUG: 잘못된 입력이 있습니다.")
      completionHandler(false)
      return
    }
    let requestDTO = UserIdSearchRequestDTO(id: signUpModel.id)
    signUpRepository.duplicateCheck(requestDTO) { state in
      completionHandler(state)
    }
  }
}
