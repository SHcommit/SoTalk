//
//  UserRepositoryImpl.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/09.
//

import Foundation

struct UserRepositoryImpl: UserRepository {
  typealias Endpoints = UserAPIEndpoints
  let provider = ServiceProviderImpl()
  
  func fetchUserInfo(
    _ userId: UserIdSearchRequestDTO,
    completionHandler: @escaping (UserInfoModel) -> Void
  ) {
    let endpoint = Endpoints.shared.searchUser(with: userId)
    provider.request(with: endpoint) { result in
      switch result {
      case .success(let response):
        let userInfo = UserInfoModel(
          id: response.userId,
          name: response.name,
          nickname: response.nickname,
          profileUrl: response.profileImgUrl)
        completionHandler(userInfo)
      case .failure(let error):
        print("DEBUG: fetchUserInfo에서 에러 : \(error.localizedDescription)")
      }
    }
  }
  
  func uploadProfile(
    _ profileUploadRequsetDTO: ProfileUploadRequestDTO,
    completionHandler: @escaping (String) -> Void
  ) {
    let endpoint = Endpoints.shared.uploadProfile(with: profileUploadRequsetDTO)
    provider.request(with: endpoint) { result in
      switch result {
      case .success(let response):
        completionHandler(response.url)
      case .failure(let error):
        print("DEBUG: uplodProfile에서 에러: \(error.localizedDescription)")
      }
    }
  }
  
  func fetchProfile(
    _ url: URL,
    completionHandler: @escaping (Data) -> Void
  ) {
    provider.request(url) { result in
      switch result {
      case .success(let response):
        print(response)
        completionHandler(response)
      case .failure(let error):
        print("DEBUG: error!!!: \(error.localizedDescription)")
      }
    }
  }
}
