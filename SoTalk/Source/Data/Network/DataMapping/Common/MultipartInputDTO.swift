//
//  MultipartInputDTO.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/05.
//

import Foundation

/// 이미지 전송할 때 타입이 Multipartfile 인 경우
///
/// Example
/// ```
/// let multiPartDTO = MultipartInputDTO(
///   userId: profileUploadRequestDTO.userId,
///   fieldName: "file",
///   fileName: "profile.jpeg",
///   mimeType: "image/jpeg",
///   fileData: profileUploadRequestDTO.imageData,
///   boundary: boundary)
/// ```

struct MultipartInputDTO {
  let userId: String
  let fieldName: String
  let fileName: String
  let mimeType: String
  let fileData: Data
  let boundary: String
  
  init(
    userId: String,
    fieldName: String,
    fileName: String,
    mimeType: String,
    fileData: Data,
    boundary: String = UUID().uuidString) {
    self.userId = userId
    self.fieldName = fieldName
    self.fileName = fileName
    self.mimeType = mimeType
    self.fileData = fileData
    self.boundary = boundary
  }
}
