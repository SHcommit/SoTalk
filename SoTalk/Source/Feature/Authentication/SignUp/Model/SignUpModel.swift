//
//  SignUpModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/28.
//

import Foundation

struct SignUpModel: Encodable {
  var id: String = ""
  var name: String = ""
  var password: String = ""
  var nickname: String = ""
}
