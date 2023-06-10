//
//  GroupInfoListResponseDTO+Mapping.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import Foundation

struct GroupInfoListResponseDTO: Decodable {
  let result: [GroupInfoResponseDTO]
  
  enum CodingKeys: String, CodingKey {
    case result
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.result = try container.decode([GroupInfoResponseDTO].self, forKey: .result)
  }
}
