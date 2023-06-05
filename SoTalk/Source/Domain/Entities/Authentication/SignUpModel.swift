//
//  SignUpModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/05.
//

import Foundation

struct SignUpModel {
  var id: String = ""
  var name: String = ""
  var password: String = ""
  var nickname: String = ""
}

extension SignUpModel {
  var isIdValidLength: Bool {
    (2...10).contains(id.count)
  }
  
  var isNameValidLength: Bool {
    (2...30).contains(name.count)
  }
  
  var isPasswordValidLength: Bool {
    (2...20).contains(password.count)
  }
 
  var isNicknameValidLength: Bool {
    (2...10).contains(nickname.count)
  }
  
  var isValidValues: Bool {
    (isIdValidLength &&
     isNameValidLength &&
     isPasswordValidLength &&
     isNicknameValidLength)
  }
}
