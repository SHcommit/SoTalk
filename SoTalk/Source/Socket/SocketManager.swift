//
//  SocketManagerImpl.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/11.
//

import Foundation
import Combine

final class SocketManager {
  // MARK: - Constant
  private let RecvSize = 1000
  private let backgroundQueue = DispatchQueue(label: "com.tcp.bindFromServerQueue", qos: .background)
  
  // MARK: - Properties
  private var groupMessageRoomPort: Int
  private var ownerSocket: Int32 = socket(AF_INET, SOCK_STREAM, 0)
  private let groupId: Int
  private var servAddr = sockaddr_in()
  private var isInitRecv = true
  let recvEvent = PassthroughSubject<MessageResponseModel, Never>()
  
  // MARK: - Initialization
  init(groupMessageRoomPort: Int, groupId: Int) {
    self.groupMessageRoomPort = groupMessageRoomPort
    self.groupId = groupId
  }
}

// MARK: - Entry point
extension SocketManager {
  func run() {
    do {
      try initServSocket()
      try connectSocket()
      try joinTheServerSocket { [weak self] in
        print("DEBUG: Start recv infinite loop")
        self?.backgroundQueue.async { [weak self] in
          self?.listenServerSendFromBackgroundQueue()
        }
      }
    } catch let sockErr as SocketError {
      print("DEBUG: Error occured in run method\n\tDescription: \(sockErr.description)")
    } catch let error {
      print("DEBUG: Unexpected error occured in run(). \(error.localizedDescription)")
    }
  }
}

// MARK: - Helpers
extension SocketManager {
  func closeSocket() {
    close(ownerSocket)
  }
}

// MARK: - Main logic
extension SocketManager {
  func sendFor(
    _ text: String,
    sendType: SocketJsonKeyType
  ) throws {
    let jsonText = SocketUtils.shared.strToJosn(text, sendKey: sendType)
    // 지금 그냥 jsonStr보내면 한글 보낼 때 글자 깨져서..
    
    //let res = send(ownerSocket, jsonText, jsonText.count, 0)
    let jsonData = SocketUtils.shared.jsonStrToBytes(jsonText)
    // data로 바꾸고 보내려함
    
    let res = jsonData.withUnsafeBytes { (bufferPointer: UnsafeRawBufferPointer) -> Int in
      let rawPointer = bufferPointer.baseAddress?.assumingMemoryBound(to: UInt8.self)
      let bufferSize = bufferPointer.count
      return send(ownerSocket, rawPointer, bufferSize, 0)

    }
    
    try SocketUtils.shared.ckeckError(res, actionType: .send)
  }
  
  private func recvFromServer() throws -> (bytes: [CChar], size: Int) {
    // 초기에는 cString으로 변환하지 않아도 됩니다.
    var buf = [CChar](repeating: 0, count: RecvSize)
    let res = recv(ownerSocket, &buf, RecvSize, 0)
    try SocketUtils.shared.ckeckError(res, actionType: .recv)
    return (buf, res)
  }
  
  private func recvFromServerWithMessage(buf: [CChar]) -> String {
    if let cString = buf.withUnsafeBufferPointer({ $0.baseAddress }) {
      return String(cString: cString)
    }
    return ""
  }
  
  /// Listening server's send data with background queue :)
  private func listenServerSendFromBackgroundQueue() {
    var isRunning = true
    while isRunning {
      do {
        let result = try recvFromServer()
        let jsonStr = recvFromServerWithMessage(buf: result.bytes)
        if !jsonStr.isEmpty, let jsonData = jsonStr.data(using: .utf8) {
          if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
            let model = try JSONDecoder().decode(
              MessageResponseModel.self,
              from: JSONSerialization.data(withJSONObject: jsonObject))
            print("DEBUG: recv model: \(model)")
            recvEvent.send(model)
          }
        }
      } catch let sockErr as SocketError {
        print("DEBUG: Error occured from background queue\n\tDescriptions:  \(sockErr.description)")
        isRunning = false
      } catch let error {
        print("DEBUG: Error occured from background queue\n\tDescriptions:  \(error.localizedDescription)")
        isRunning = false
      }
    }
  }
}

// MARK: - Private helpers
extension SocketManager {
  /// Initial server's socket and check owner's client socket
  private func initServSocket() throws {
    if ownerSocket == -1 { throw SocketError.InvalidOwnerSocket }
    let servIp = SecretManager.shared.serverIp
    servAddr.sin_family = sa_family_t(AF_INET)
    servAddr.sin_port = CFSwapInt16HostToBig(UInt16(groupMessageRoomPort))
    servAddr.sin_addr.s_addr = inet_addr(servIp)
  }
  
  private func connectSocket() throws {
    let connectedState = withUnsafePointer(
      to: &servAddr
    ) { servAddr in
      servAddr.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        connect(
          ownerSocket,
          $0,
          socklen_t(MemoryLayout<sockaddr_in>.size))
      }
    }
    if connectedState == -1 {
      throw SocketError.FailedToConnectTheServer
    }
  }
  
  /// 1. 서버에서 다음과 같은 json str 받기 " { \"action\":\"request_id\"}\n
  /// 2. key 값이 request_id인지 확인 후 "{\"userId\":\"owner's unique id 값\"}  보내기
  /// 3. 통신 시작
  private func joinTheServerSocket(completion: @escaping () -> Void) throws {
    let initialResponseValue = try checkInitialServerRecv()
    if initialResponseValue == "request_id" {
      do {
        let userId = AppSetting.getUser().id
        try sendFor("\(userId)", sendType: .userId)
        let result = try self.recvFromServer()
        let data = Data(bytes: result.bytes, count: result.size)
        try checkIsInitlaiRecv(data)
        completion()
      } catch let error {
        print("DEBUG: Error occured in join the server socket. \(error.localizedDescription)")
      }
    }
  }
  
  /// 서버에서 다음과 같은 json str 받기 " { \"action\":\"request_id\"}\n
  private func checkInitialServerRecv() throws -> String {
    guard let res = try? recvFromServer() else { throw SocketError.FailedToConnectTheServer }
    let recvData = Data(bytes: res.bytes, count: res.size)
    let decoder = JSONDecoder()
    let model = try decoder.decode(InitResponseModel.self, from: recvData)
    return model.action
  }
  
  private func checkIsInitlaiRecv(_ data: Data) throws {
    if isInitRecv {
      isInitRecv = false
      let dict = try SocketUtils.shared.dataToDictionary(data)
      if let status = dict["status"] as? String,
         status == "405" {
        throw SocketError.InvalidUserId
      } else if let status = dict["status"] as? String,
                status == "200" {
        print("DEBUG: Successfully connect to server with socket :)")
        return
      }
      throw SocketError.UnexpectedStatus
    }
  }
  
  private func mapRecvData(_ data: Data) throws -> [String: Any] {
    try checkIsInitlaiRecv(data)
    return try SocketUtils.shared.dataToDictionary(data)
  }
}
