//
//  GroupSocketPortSearchResponseDTO.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import Foundation

struct GroupSocketPortSearchResponseDTO {
  let port: Int
  enum CodingKeys: String, CodingKey {
    case port
  }
}

extension GroupSocketPortSearchResponseDTO: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    port = try container.decode(Int.self, forKey: .port)
  }
}
