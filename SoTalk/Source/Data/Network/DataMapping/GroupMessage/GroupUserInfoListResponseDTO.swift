//
//  GroupUserInfoListResponseDTO.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import Foundation

struct GroupUserInfoListResponseDTO {
  let list: [GroupUserInfoResponseDTO]
  
  enum CodingKeys: String, CodingKey {
    case list = "result"
  }
}

extension GroupUserInfoListResponseDTO: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    list = try container.decode([GroupUserInfoResponseDTO].self, forKey: .list)
  }
}
