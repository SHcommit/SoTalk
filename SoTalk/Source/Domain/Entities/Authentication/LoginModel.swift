//
//  LoginModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/05.
//

import Foundation

struct LoginModel {
  var id: String = ""
  var password: String = ""
}

// MARK: - Helper
extension LoginModel {
  var isValidIdLength: Bool {
    (2...8).contains(id.count)
  }
  
  var isValidPasswordLength: Bool {
    (2...20).contains(password.count)
  }
  
  var isValidAllValues: Bool {
    isValidIdLength && isValidPasswordLength
  }
}
