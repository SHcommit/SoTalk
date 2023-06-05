//
//  SignUpResponseDTO+Mapping.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/05.
//

import Foundation

struct SignUpResponseDTO {
  let id: String
  enum CodingKeys: String, CodingKey {
    case id = "userId"
  }
}

extension SignUpResponseDTO: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
  }
}
