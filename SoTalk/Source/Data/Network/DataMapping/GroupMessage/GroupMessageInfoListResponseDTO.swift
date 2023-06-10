//
//  GroupMessageInfoListResponseDTO.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import Foundation

struct GroupMessageInfoListResponseDTO {
  let list: [GroupMessageInfoResponseDTO]
  
  enum CodingKeys: String, CodingKey {
    case list = "result"
  }
}

extension GroupMessageInfoListResponseDTO: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    list = try container.decode([GroupMessageInfoResponseDTO].self, forKey: .list)
  }
}
