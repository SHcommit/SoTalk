//
//  GroupProfileUploadRequestDTO.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import Foundation

struct GroupProfileUploadRequestDTO: Encodable {
  let groupId: Int
  let imageData: Data
}
