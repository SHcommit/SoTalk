//
//  GroupProfileUploadResponseDTO+Mapping.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import Foundation

struct GroupProfileUploadResponseDTO {
  let url: String
  
  enum CodingKeys: String, CodingKey {
    case url
  }
}

extension GroupProfileUploadResponseDTO: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    url = try container.decode(String.self, forKey: .url)
  }
}
