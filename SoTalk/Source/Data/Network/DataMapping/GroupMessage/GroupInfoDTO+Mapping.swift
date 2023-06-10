//
//  GroupInfoResponseDTO+Mapping.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import Foundation

struct GroupInfoResponseDTO {
  let groupId: Int
  let groupName: String
  let groupImageUrl: String
  let memberCount: Int
  
  enum CodingKeys: String, CodingKey {
    case groupId
    case groupName
    case groupImageUrl = "groupImgUrl"
    case memberCount = "people"
  }
}

extension GroupInfoResponseDTO: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    groupId = try container.decode(Int.self, forKey: .groupId)
    groupName = try container.decode(String.self, forKey: .groupName)
    groupImageUrl = try container.decode(String.self, forKey: .groupImageUrl)
    memberCount = try container.decode(Int.self, forKey: .memberCount)
  }
}
