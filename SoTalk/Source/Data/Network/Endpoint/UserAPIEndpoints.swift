//
//  UserAPIEndpoints.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/05.
//

import Foundation

struct UserAPIEndpoints {
  static func signUp(with signUpRequestDTO: SignUpRequestDTO) -> Endpoint<SignUpRequestDTO> {
    return Endpoint(
      path: "user/signup",
      method: .post,
      bodyParameters: signUpRequestDTO,
      headers: ["Content-Type": "application/json"])
  }
  
  static func duplicateCheck(
    with userDuplicatedCheckRequestDTO: UserIdSearchRequestDTO
  ) -> Endpoint<UserIdSearchRequestDTO> {
    return Endpoint(
      path: "user/duplicateCheck",
      method: .get,
      queryParameters: userDuplicatedCheckRequestDTO)
  }
  
  static func signIn(
    with signInRequestDTO: SignInRequestDTO
  ) -> Endpoint<SignInRequestDTO> {
    return Endpoint(
      path: "user/login",
      method: .post,
      bodyParameters: signInRequestDTO,
      headers: ["Content-Type": "application/json"])
  }
  
  static func searchProfile(
    with userIdSearchRequestDTO: UserIdSearchRequestDTO
  ) -> Endpoint<UserIdSearchRequestDTO> {
    return Endpoint(
      path: "user/byUserId",
      method: .get,
      queryParameters: userIdSearchRequestDTO)
  }
  
  static func uploadProfile(
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
  
  static func fetchProfile(
    with userIdDTO: UserIdSearchRequestDTO
  ) -> Endpoint<UserIdSearchRequestDTO> {
    return Endpoint(
      path: "user/profile",
      method: .get,
      queryParameters: userIdDTO)
  }
  
  static func deleteProfile(
    with userIdDTO: UserIdSearchRequestDTO
  ) -> Endpoint<UserIdSearchRequestDTO> {
    return Endpoint(
      path: "user/profile",
      method: .delete,
      queryParameters: userIdDTO)
  }
}
