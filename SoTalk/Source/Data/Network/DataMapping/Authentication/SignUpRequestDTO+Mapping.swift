//
//  SignUpRequestDTO+Mapping.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/28.
//

import Foundation

struct SignUpRequestDTO: Codable {
  let id: String
  let name: String
  let password: String
  let nickname: String
  
  enum CodingKeys: String, CodingKey {
    case id = "userId"
    case name
    case password
    case nickname
  }
}

// MARK: - Encodable
extension SignUpRequestDTO {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(nickname, forKey: .nickname)
    try container.encode(password, forKey: .password)
  }
}

// MARK: - Decodable
extension SignUpRequestDTO {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    password = try container.decode(String.self, forKey: .password)
    nickname = try container.decode(String.self, forKey: .nickname)
  }
}
