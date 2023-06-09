//
//  GroupMessageAPIEndpoints.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/05.
//

import Foundation

struct GroupMessageAPIEndpoints {
  static let shared = GroupMessageAPIEndpoints()
  private init() { }
  
  func fetchGroupSocketPort(
    with groupId: GroupSocketPortSearchRequestDTO
  ) -> Endpoint<GroupSocketPortSearchResponseDTO> {
    return Endpoint<GroupSocketPortSearchResponseDTO>(
      path: "socket/port",
      method: .get,
      queryParameters: groupId,
      headers: ["Content-Type": "application/json"])
  }
  
  func addNewMessageGroup(
    with newMessageGroup: NewMessageGroupRequestDTO
  ) -> Endpoint<GroupSocketPortSearchResponseDTO> {
    return .init(
      path: "group/add",
      method: .post,
      bodyParameters: newMessageGroup,
      headers: ["Content-Type": "application/json"])
  }
  
  func joinGroup(with groupJoinDTO: GroupJoinRequestDTO
  ) -> Endpoint<GroupSocketPortSearchResponseDTO> {
    return .init(
      path: "group/join",
      method: .post,
      bodyParameters: groupJoinDTO,
      headers: ["Content-Type": "application/json"])
  }
  
  func fetchAllGrupInfo() -> Endpoint<GroupInfoResponseDTO> {
    return .init(
      path: "group/list",
      method: .get,
    bodyParameters: nil,
    headers: ["Content-Type": "application/json"])
  }
  
  func fetchJoinedAllGroupInfo(
    with userIdDTO: UserIdSearchRequestDTO
  ) -> Endpoint<GroupInfoResponseDTO> {
    return .init(
      path: "group/listByUserId",
      method: .get,
      bodyParameters: userIdDTO,
      headers: ["Content-Type": "application/json"])
  }
}
