//
//  UserAPIEndpoints.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/05.
//

import Foundation

struct UserAPIEndpoints {
  func searchProfile(
    with userIdSearchRequestDTO: UserIdSearchRequestDTO
  ) -> Endpoint<UserIdSearchRequestDTO> {
    return Endpoint(
      path: "user/byUserId",
      method: .get,
      queryParameters: userIdSearchRequestDTO)
  }
  
  func uploadProfile(
    with profileUploadRequestDTO: ProfileUploadRequestDTO
  ) -> Endpoint<ProfileUploadRequestDTO> {
    let boundary = UUID().uuidString
    let multiPartDTO = MultipartInputDTO(
      userId: profileUploadRequestDTO.userId,
      fieldName: "file",
      fileName: "profile.jpeg",
      mimeType: "image/jpeg",
      fileData: profileUploadRequestDTO.imageData,
      boundary: boundary)
    return Endpoint(
      path: "user/profile",
      method: .post,
      headers: [
        "Content-Type": "multipart/form-data; boundary=\(boundary)",
        "boundary": boundary],
      multipartDTO: multiPartDTO)
  }
  
  func fetchProfile(
    with userIdDTO: UserIdSearchRequestDTO
  ) -> Endpoint<UserIdSearchRequestDTO> {
    return Endpoint(
      path: "user/profile",
      method: .get,
      queryParameters: userIdDTO)
  }
  
  func deleteProfile(
    with userIdDTO: UserIdSearchRequestDTO
  ) -> Endpoint<UserIdSearchRequestDTO> {
    return Endpoint(
      path: "user/profile",
      method: .delete,
      queryParameters: userIdDTO)
  }
}
