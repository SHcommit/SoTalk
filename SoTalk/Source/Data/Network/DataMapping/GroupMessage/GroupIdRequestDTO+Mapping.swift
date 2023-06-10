//
//  GroupIdRequestDTO+Mapping.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import Foundation

struct GroupIdRequestDTO {
  let groupId: Int
  
  enum CodingKeys: String, CodingKey {
    case groupId
  }
}

extension GroupIdRequestDTO: Encodable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(groupId, forKey: .groupId)
  }
}
