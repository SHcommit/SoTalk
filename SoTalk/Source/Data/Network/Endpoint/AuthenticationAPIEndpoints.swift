//
//  AuthenticationAPIEndpoints.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/05.
//

import Foundation

struct AuthenticationAPIEndpoints {
  static let shared = AuthenticationAPIEndpoints()
  private init() { }
  
  func signUp(with signUpRequestDTO: SignUpRequestDTO) -> Endpoint<SignUpResponseDTO> {
    return Endpoint<SignUpResponseDTO>(
      path: "user/signup",
      method: .post,
      bodyParameters: signUpRequestDTO,
      headers: ["Content-Type": "application/json"])
  }
  
  func duplicateCheck(
    with userDuplicatedCheckRequestDTO: UserIdSearchRequestDTO
  ) -> Endpoint<UserIdSearchResponseDTO> {
    return Endpoint(
      path: "user/duplicateCheck",
      method: .get,
      queryParameters: userDuplicatedCheckRequestDTO)
  }
  
  func Login(
    with signInRequestDTO: LoginRequestDTO
  ) -> Endpoint<SignUpResponseDTO> {
    return Endpoint(
      path: "user/login",
      method: .post,
      bodyParameters: signInRequestDTO,
      headers: ["Content-Type": "application/json"])
  }
}
