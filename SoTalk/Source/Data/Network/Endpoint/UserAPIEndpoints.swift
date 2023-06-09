//
//  UserAPIEndpoints.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/05.
//

import Foundation

struct UserAPIEndpoints {
  static let shared = UserAPIEndpoints()
  private init() { }
  
  func searchUser(
    with userIdSearchRequestDTO: UserIdSearchRequestDTO
  ) -> Endpoint<UserInfoResponseDTO> {
    return Endpoint<UserInfoResponseDTO>(
      path: "user/byUserId",
      method: .get,
      queryParameters: userIdSearchRequestDTO)
  }
  
  func uploadProfile(
    with profileUploadRequestDTO: ProfileUploadRequestDTO
  ) -> Endpoint<ProfileUploadURLDTO> {
    let boundary = UUID().uuidString
    let multiPartDTO = MultipartInputDTO(
      userId: profileUploadRequestDTO.userId,
      fieldName: "file",
      fileName: "profile.jpeg",
      mimeType: "image/jpeg",
      fileData: profileUploadRequestDTO.imageData,
      boundary: boundary)
    return Endpoint<ProfileUploadURLDTO>(
      path: "user/profile",
      method: .post,
      headers: [
        "Content-Type": "multipart/form-data; boundary=\(boundary)",
        "boundary": boundary],
      multipartDTO: multiPartDTO)
  }
  
  func fetchProfile(
    with url: ProfileUploadURLDTO
  ) -> Endpoint<Data> {
    return Endpoint(
      path: "user/profile",
      method: .get,
      queryParameters: url)
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
