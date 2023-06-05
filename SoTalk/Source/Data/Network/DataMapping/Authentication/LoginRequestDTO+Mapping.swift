//
//  LoginRequestDTO+Mapping.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/03.
//

import Foundation

struct SignInRequestDTO {
  let id: String
  let password: String
  
  enum CodingKeys: String, CodingKey {
    case id = "userId"
    case password
  }
}

extension SignInRequestDTO: Encodable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(password, forKey: .password)
  }
}
