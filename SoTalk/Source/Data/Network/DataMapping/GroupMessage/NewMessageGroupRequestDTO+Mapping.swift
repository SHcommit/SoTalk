//
//  NewMessageGroupRequestDTO+Mapping.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import Foundation

struct NewMessageGroupRequestDTO {
  let groupName: String
  let userId: String
  
  enum CodingKeys: String, CodingKey {
    case groupName
    case userId
  }
}

extension NewMessageGroupRequestDTO: Encodable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(groupName.self, forKey: .groupName)
    try container.encode(userId.self, forKey: .userId)
  }
}
