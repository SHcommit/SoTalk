//
//  ProfileFetchResponseDTO+Mapping.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import Foundation

struct ProfileFetchResponseDTO {
  let imageData: Data
  
  enum CodingKeys: String, CodingKey {
    case imageData
  }
}
extension ProfileFetchResponseDTO: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let bytes = try container.decode([UInt8].self, forKey: .imageData)
    imageData = Data(bytes)

  }
}
