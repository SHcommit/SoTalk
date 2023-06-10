//
//  GroupUserInfoResponseDTO+Mapping.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import Foundation

struct GroupUserInfoResponseDTO {
  let userId: String
  let nickname: String
  let profileImgUrl: String
  
  enum CodingKeys: String, CodingKey {
    case userId
    case nickname
    case profileImgUrl
  }
}

extension GroupUserInfoResponseDTO: Decodable {
  init(from decoder: Decoder) throws {
    var container = try decoder.container(keyedBy: CodingKeys.self)
    userId = try container.decode(String.self, forKey: .userId)
    nickname = try container.decode(String.self, forKey: .nickname)
    profileImgUrl = try container.decode(String.self, forKey: .profileImgUrl)
  }
}
