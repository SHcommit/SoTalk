//
//  GroupMessageRepositoryImpl.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import Foundation

struct GroupMessageRepositoryImpl: GroupMessageRepository {
  typealias Endpoints = GroupMessageAPIEndpoints
  private let provider = ServiceProviderImpl()
  
  func fetchGroupSocketPort(
    with groupId: GroupSocketPortSearchRequestDTO,
    completionHandler: @escaping (Int) -> Void
  ) {
    let endpoint = Endpoints.shared.fetchGroupSocketPort(with: groupId)
    provider.request(with: endpoint) { result in
      switch result {
      case .success(let response):
        completionHandler(response.port)
      case .failure(let error):
        print("DEBUG: Failed to fetch group socket port.  \(error.localizedDescription)")
      }
    }
  }
  
  func addNewMessageGroup(
    with newMessageGroup: NewMessageGroupRequestDTO,
    completionHandler: @escaping (Int) -> Void
  ) {
    let endpoint = Endpoints.shared.addNewMessageGroup(with: newMessageGroup)
    provider.request(with: endpoint) { result in
      switch result {
      case .success(let response):
        completionHandler(response.groupId)
      case .failure(let error):
        print("DEBUG: Failed to add new message group. \(error.localizedDescription)")
      }
    }
  }
  
  func joinGroup(
    with groupJoinDTO: GroupJoinRequestDTO,
    completionHandler: @escaping (Int) -> Void
  ) {
    let endpoint = Endpoints.shared.joinGroup(with: groupJoinDTO)
    provider.request(with: endpoint) { result in
      switch result {
      case .success(let response):
        completionHandler(response.port)
      case .failure(let error):
        print("DEBUG: Failed to join specific group. \(error.localizedDescription)")
      }
    }
  }
  
  func fetchAllGrupList(
    completionHandler: @escaping ([GroupMessageRoomInfoModel]) -> Void
  ) {
    let endpoint = Endpoints.shared.fetchAllGrupList()
    provider.request(with: endpoint) { result in
      switch result {
      case .success(let response):
        completionHandler(
          response.map {
            return GroupMessageRoomInfoModel(
              groupId: $0.groupId,
              groupName: $0.groupName,
              memberCount: $0.memberCount,
              profileUrl: $0.groupImageUrl)})
      case .failure(let error):
        print("DEBUG: Failed to fetch all gorup list. \(error.localizedDescription)")
      }
    }
  }
  
  func fetchUserJoinedAllGroupInfo(
    with userIdDTO: UserIdSearchRequestDTO,
    completionHandler: @escaping ([GroupMessageRoomInfoModel]) -> Void
  ) {
    let endpoint = Endpoints.shared.fetchUserJoinedAllGroupInfo(with: userIdDTO)
    provider.request(with: endpoint) { result in
      switch result {
      case .success(let response):
        completionHandler(
          response.map {
            return GroupMessageRoomInfoModel(
              groupId: $0.groupId,
              groupName: $0.groupName,
              memberCount: $0.memberCount,
              profileUrl: $0.groupImageUrl)})
      case .failure(let error):
        print("DEBUG: Failed to fetch user joined all gorup info. \(error.localizedDescription)")
      }
    }
  }
  
  func searchJoinedAllUserInfoInGroup(
    with groupIdDTO: GroupIdRequestDTO,
    completionHandler: @escaping ([GroupMessageUserInfoModel]) -> Void
  ) {
    let endpoint = Endpoints.shared.searchJoinedAllUserInfoInGroup(with: groupIdDTO)
    provider.request(with: endpoint) { result in
      switch result {
      case .success(let response):
        completionHandler(
          response.map {
            return GroupMessageUserInfoModel(
              userId: $0.userId,
              nickname: $0.nickname,
              profileUrl: $0.profileImgUrl)})
      case .failure(let error):
        print("DEBUG: Failed to search joined all user info in group. \(error.localizedDescription)")
      }
    }
  }
  
  func uploadGroupProfile(
    with requestDTO: GroupProfileUploadRequestDTO,
    completionHandler: @escaping (String) -> Void
  ) {
    let endpoint = Endpoints.shared.uploadGroupProfile(with: requestDTO)
    provider.request(with: endpoint) { result in
      switch result {
      case .success(let response):
        completionHandler(response.url)
      case .failure(let error):
        print("DEBUG: Failed to upload group profie. \(error.localizedDescription)")
      }
    }
  }
  
  func fetchGroupProfile(
    with bodyParam: String,
    completionHandler: @escaping (Data) -> Void
  ) {
    let endpoint = Endpoints.shared.fetchGroupProfile(with: bodyParam)
    guard let url = URL(string: endpoint) else {
      print("DEBUG: Failed converting url strong to URL instance")
      return
    }
    provider.request(url) { result in
      switch result {
      case .success(let data):
        completionHandler(data)
      case .failure(let error):
        print("DEBUG: failed to fetch group profile image. \(error.localizedDescription)")
      }
    }
  }
  
  func fetchAllMessageInSpecificGroup(
    with requestDTO: GroupIdRequestDTO,
    completionHandler: @escaping ([GroupMessageInfoModel]) -> Void
  ) {
    let endpoint = Endpoints.shared.fetchAllMessageInSpecificGroup(with: requestDTO)
    provider.request(with: endpoint) { result in
      switch result {
      case .success(let response):
        completionHandler(
          response.map {
            return GroupMessageInfoModel(
              userId: $0.userId,
              message: $0.message,
              sendTime: $0.sendTime)})
      case .failure(let error):
        print("DEBUG: Failed to fetch all message in specific group. \(error.localizedDescription)")
      }
    }
  }
}
