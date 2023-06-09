//
//  GroupJoinRequestDTO+Mapping.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import Foundation

struct GroupJoinRequestDTO {
  let groupId: Int
  let userId: String
  
  enum CodingKeys: String, CodingKey {
    case groupId
    case userId
  }
}

extension GroupJoinRequestDTO: Encodable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(groupId.self, forKey: .groupId)
    try container.encode(userId.self, forKey: .userId)
  }
}
