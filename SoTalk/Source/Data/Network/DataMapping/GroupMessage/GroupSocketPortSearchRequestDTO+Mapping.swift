//
//  GroupSocketPortSearchRequestDTO.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import Foundation

struct GroupSocketPortSearchRequestDTO: Encodable {
  let id: String
  
  enum CodingKeys: String, CodingKey {
    case id = "groupId"
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
  }
}
