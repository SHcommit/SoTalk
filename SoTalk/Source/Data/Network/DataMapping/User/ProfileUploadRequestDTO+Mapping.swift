//
//  ProfileUploadRequestDTO+Mapping.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/05.
//

import Foundation

struct ProfileUploadRequestDTO: Encodable {
  let userId: String
  let imageData: Data
}
