//
//  SocketModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/11.
//

import Foundation

// MARK: - SocketError
enum SocketError: Error {
  case FailedToSendMessage
  case FailedToRecvMessage
  case FailedToConvertDataToDict
  case FailedToConnectTheServer
  case InvalidUserId
  case InvalidOwnerSocket
  case UnexpectedStatus
}

extension SocketError: CustomStringConvertible {
  var description: String {
    switch self {
    case .FailedToSendMessage:
      return "Failed to send to server with message"
    case .FailedToRecvMessage:
      return "Failed to recv from server's message"
    case .FailedToConvertDataToDict:
      return "Failed to convert data to dictionary"
    case .FailedToConnectTheServer:
      return "Failed to connect the server :("
    case .InvalidUserId:
      return "Invalid userId. It isn't existing in server's db."
    case .InvalidOwnerSocket:
      return "Invalid owner's client socket."
    case .UnexpectedStatus:
      return "Unexpected cstatus received."
    }
  }
}

// MARK: - InitResponse From server's recv model
struct InitResponseModel: Decodable {
  let action: String
  
  enum CodingKeys: CodingKey {
    case action
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.action = try container.decode(String.self, forKey: .action)
  }
}

// MARK: - SocketJsonKeyType
enum SocketJsonKeyType: String {
  case userId
  case message
  case action
  case status
}


// MARK: - SocketActionType
enum SocketActionType {
  case send
  case recv
}

// MARK: - Socket's recv model
struct MessageResponseModel: Decodable {
  let groupId: String
  let userId: String
  let message: String
  let type: String
  
  enum CodingKeys: CodingKey {
    case groupId
    case userId
    case message
    case type
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.groupId = try container.decode(String.self, forKey: .groupId)
    self.userId = try container.decode(String.self, forKey: .userId)
    self.message = try container.decode(String.self, forKey: .message)
    self.type = try container.decode(String.self, forKey: .type)
  }
}
