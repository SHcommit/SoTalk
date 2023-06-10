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
  ) -> Endpoint<GroupJoinResponseDTO> {
    return Endpoint<GroupJoinResponseDTO>(
      path: "socket/port",
      method: .get,
      queryParameters: groupId,
      headers: ["Content-Type": "application/json"])
  }
  
  // 받은 후에는 서버한테 다시 group list fetch해야함
  // 이미지 바로 전송
  func addNewMessageGroup(
    with newMessageGroup: NewMessageGroupRequestDTO
  ) -> Endpoint<NewMessageGroupResponseDTO> {
    return .init(
      path: "group/add",
      method: .post,
      bodyParameters: newMessageGroup,
      headers: ["Content-Type": "application/json"])
  }
  
  func joinGroup(with groupJoinDTO: GroupJoinRequestDTO
  ) -> Endpoint<GroupJoinResponseDTO> {
    return .init(
      path: "group/join",
      method: .post,
      bodyParameters: groupJoinDTO,
      headers: ["Content-Type": "application/json"])
  }
  
  func fetchAllGroupList() -> Endpoint<GroupInfoListResponseDTO> {
    return .init(
      path: "group/list",
      method: .get,
    bodyParameters: nil,
    headers: ["Content-Type": "application/json"])
  }
}

// MARK: - User Endpoint
extension GroupMessageAPIEndpoints {
  func fetchUserJoinedAllGroupInfo(
    with userIdDTO: UserIdSearchRequestDTO
  ) -> Endpoint<GroupInfoListResponseDTO> {
    return .init(
      path: "group/listByUserId",
      method: .get,
      bodyParameters: userIdDTO,
      headers: ["Content-Type": "application/json"])
  }
  
  func searchJoinedAllUserInfoInGroup(
    with groupIdDTO: GroupIdRequestDTO
  ) -> Endpoint<GroupUserInfoListResponseDTO> {
    return .init(
      path: "group/users",
      method: .get,
      bodyParameters: groupIdDTO,
      headers: ["Content-Type": "application/json"])
  }
}

// MARK: - Image Endpoint
extension GroupMessageAPIEndpoints {
  func uploadGroupProfile(
    with requestDTO: GroupProfileUploadRequestDTO
  ) -> Endpoint<GroupProfileUploadResponseDTO> {
    let boundary = UUID().uuidString
    let multiPartDTO = MultipartInputDTO(
      groupId: requestDTO.groupId,
      fieldName: "file",
      fileName: "profile.jpeg",
      mimeType: "image/jpeg",
      fileData: requestDTO.imageData,
      boundary: boundary)
    return .init(
      path: "group/img",
      method: .post,
      queryParameters: nil,
      headers: [
        "Content-Type": "multipart/form-data; boundary=\(boundary)",
        "boundary": boundary],
      multipartDTO: multiPartDTO)
  }
  
  func fetchGroupProfile(
    with bodyParam: String
  ) -> String {
    let servIp = SecretManager.shared.serverIp
    let servPort = SecretManager.shared.serverPort
    let path = "group/img"
    return "http://\(servIp):\(servPort)/\(path)?url=\(bodyParam)"
  }
}

// MARK: - Chat
extension GroupMessageAPIEndpoints {
  /// get일때 header안넣어도되나?
  /// headers: ["Content-Type": "application/json"]
  func fetchAllMessageInSpecificGroup(
    with requestDTO: GroupIdRequestDTO
  ) -> Endpoint<GroupMessageInfoListResponseDTO> {
    return .init(
      path: "chat/group",
      method: .get,
      queryParameters: requestDTO)
  }
}
