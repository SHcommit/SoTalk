//
//  UserIdRequestDTO+Mapping.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/05.
//

import Foundation

struct UserIdSearchRequestDTO: Encodable {
  let id: String
  
  enum CodingKeys: String, CodingKey {
    case id = "userId"
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
  }
}
