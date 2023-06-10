//
//  GroupMessageRepository.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import Foundation

// MARK: - Group
protocol GroupMessageRepository {
  func fetchGroupSocketPort(
    with groupId: GroupSocketPortSearchRequestDTO,
    completionHandler: @escaping (Int) -> Void)
  
  // 받은 후에는 서버한테 다시 group list fetch해야함
  // 이미지 바로 전송
  func addNewMessageGroup(
    with newMessageGroup: NewMessageGroupRequestDTO,
    completionHandler: @escaping (Int) -> Void)
  
  func joinGroup(
    with groupJoinDTO: GroupJoinRequestDTO,
    completionHandler: @escaping (Int) -> Void)
  
  func fetchAllGrupList(
    completionHandler: @escaping ([GroupMessageRoomInfoModel]) -> Void)
  
  // MARK: - User
  func fetchUserJoinedAllGroupInfo(
    with userIdDTO: UserIdSearchRequestDTO,
    completionHandler: @escaping ([GroupMessageRoomInfoModel]) -> Void)
  
  func searchJoinedAllUserInfoInGroup(
    with groupIdDTO: GroupIdRequestDTO,
    completionHandler: @escaping ([GroupMessageUserInfoModel]) -> Void)
  
  // MARK: - Image
  func uploadGroupProfile(
    with requestDTO: GroupProfileUploadRequestDTO,
    completionHandler: @escaping (String) -> Void)
  
  func fetchGroupProfile(
    with bodyParam: String,
    completionHandler: @escaping (Data) -> Void)
  
  // MARK: - Chat
  func fetchAllMessageInSpecificGroup(
    with requestDTO: GroupIdRequestDTO,
    completionHandler: @escaping ([GroupMessageInfoModel]) -> Void)
}
