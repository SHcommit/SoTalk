//
//  UserInfoResponseDTO+Mapping.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/09.
//

import Foundation

struct UserInfoResponseDTO {
  let userId: String
  let nickname: String
  let name: String
  let profileImgUrl: String?
  
  enum CodingKeys: String, CodingKey {
    case userId
    case nickname
    case profileImgUrl
    case name
  }
}

extension UserInfoResponseDTO: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    userId = try container.decode(String.self, forKey: .userId)
    nickname = try container.decode(String.self, forKey: .nickname)
    profileImgUrl = try? container.decode(String.self, forKey: .profileImgUrl)
    name = try container.decode(String.self, forKey: .name)
  }
}
