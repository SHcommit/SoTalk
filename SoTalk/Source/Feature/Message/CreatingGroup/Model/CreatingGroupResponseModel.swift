//
//  CreatingGroupResponseModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/04.
//

struct CreatingGroupResponseModel {
  let groupInfo: CreatingGroupRequestModel
  let port: Int
  enum CodingKeys: String, CodingKey {
    case groupInfo
    case port
  }
}

// MARK: - Decodable
extension CreatingGroupResponseModel: Encodable {
  
}
