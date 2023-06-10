//
//  GroupMessageInfoResponseDTO+Mapping.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import Foundation

struct GroupMessageInfoResponseDTO {
  let userId: String
  let message: String
  let sendTime: String
  
  enum CodingKeys: String, CodingKey {
    case userId
    case message
    case sendTime = "createdAt"
  }
}

extension GroupMessageInfoResponseDTO: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    userId = try container.decode(String.self, forKey: .userId)
    message = try container.decode(String.self, forKey: .message)
    sendTime = try container.decode(String.self, forKey: .sendTime)
  }
}
