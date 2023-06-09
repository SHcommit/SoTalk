//
//  UserRepository.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/09.
//

import Foundation

protocol UserRepository {
  func fetchUserInfo(
    _ userId: UserIdSearchRequestDTO,
    completionHandler: @escaping (UserInfoModel) -> Void)
  
  func uploadProfile(
    _ profileUploadRequsetDTO: ProfileUploadRequestDTO,
    completionHandler: @escaping (String) -> Void)
  
  func fetchProfile(
    _ queryParam: String, completionHandler: @escaping (Data) -> Void)
}
