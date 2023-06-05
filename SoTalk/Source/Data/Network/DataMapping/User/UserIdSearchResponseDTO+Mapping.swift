//
//  UserIdResponseDTO+Mapping.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/05.
//

import Foundation

struct UserIdSearchResponseDTO {
  let isRegisteredUser: Bool
  enum CodingKeys: String, CodingKey {
    case isRegisteredUser = "b"
  }
}

extension UserIdSearchResponseDTO: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    isRegisteredUser = try container.decode(Bool.self, forKey: .isRegisteredUser)
  }
}
