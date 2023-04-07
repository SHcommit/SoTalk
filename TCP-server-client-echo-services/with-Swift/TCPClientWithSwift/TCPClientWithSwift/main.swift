//
//  main.swift
//  TCPClientWithSwift
//
//  Created by 양승현 on 2023/04/07.
//

import Foundation

//MARK: - Constraints
typealias ClientError = ClientTCPDispatchError
let BufSize = 1000
let Port = 4501

//MARK: - ClientTCPDispatchError
enum ClientTCPDispatchError: Error {
  case InvaildSocket
  case InvalidUserInputMessage
  case FailedToConnectToServer
  case FailedToRecvFromSocket
  case ServerClosed
  case FailedToSendMessage
  case FailedToResponseFromServer
  case FailedToDecodeDataToString
}
extension ClientTCPDispatchError: CustomStringConvertible {
  var description: String {
    switch self {
    case .FailedToConnectToServer:
      return "DEBUG: Failed to connect to server"
    case .FailedToRecvFromSocket:
      return "DEBUG: Failed to receive from server's socket"
    case .ServerClosed:
      return "DEBUG: Server's socket is closed"
    case .InvaildSocket:
      return "DEBUG: Invalid socket's instance"
    case .InvalidUserInputMessage:
      return "DEBUG: Invalid user's input message"
    case .FailedToSendMessage:
      return "DEBUG: Failed to send message"
    case .FailedToResponseFromServer:
      return "DEBUG: Failed to responsed message from server"
    case .FailedToDecodeDataToString:
      return "DEBUG: Failed to decode received data"
    }
  }
}


//MARK: - Helpers
func inputUserText() throws -> String {
  print("[send Server]Enter message:")
  guard let message = readLine() else {
    throw ClientError.InvalidUserInputMessage
  }
  return message
}

func convertStringToData(_ string: String) -> Data {
  return Data(string.utf8)
}

func sendMessageToServer(with socket: inout Int32) throws {
  let text = try inputUserText()
  if text.contains("$#END") { exit(0) }
  let data = convertStringToData(text)
  let res = send(socket, (data as NSData).bytes.bindMemory(to: CChar.self, capacity: data.count), data.count, 0)
  if res == -1 { throw ClientError.FailedToSendMessage }
  print("DEBUG: [TCP Client] \(res) 바이트를 보냈습니다.")
}


func receiveMessageFromServer(with socket: inout Int32) throws {
  var buf = [CChar](repeating: 0, count: 1000)
  let res = recv(socket, &buf, BufSize, 0)
  if res <= 0 { throw ClientError.FailedToResponseFromServer }
  
  // 바이트 배열을 문자열로 변환하여 출력
  let data = Data(bytes: buf, count: res)
  guard let message = String(data: data, encoding: .utf8) else{
    throw ClientError.FailedToDecodeDataToString
  }
  print("DEBUG: [TCP Client] Server에서 \(res) 바이트를 받았습니다.")
  print("DEBUG:   [Respond data from Server] \(message)")
}

func connectClientSocket(withServAddr servAddr: inout sockaddr_in,
                         _ clientSocket: inout Int32
) throws {
  var connectedState = withUnsafePointer(to: &servAddr) { servAddr in
    servAddr.withMemoryRebound(to: sockaddr.self, capacity: 1) {
      connect(clientSocket, $0, socklen_t(MemoryLayout<sockaddr_in>.size))
    }
  }
  if connectedState == -1 { throw ClientError.FailedToConnectToServer }
}

//MARK: - TCPClientWithSwift()
func TCPClientWithSwift() throws {
  //1. 클라이언트 측의 socket( IP, Port 정보) 생성
  var clientSocket: Int32 = socket(AF_INET, SOCK_STREAM, 0)
  if clientSocket == -1 { throw ClientError.InvaildSocket }
  
  //2. 서버 측의 socket addr 생성
  var servAddr = sockaddr_in()
  servAddr.sin_family = sa_family_t(AF_INET)
  servAddr.sin_port = CFSwapInt16HostToBig(UInt16(Port))
  servAddr.sin_addr.s_addr = inet_addr("127.0.0.1")
  
  //3. connect() 함수를 통해 tcp로 서버측에 연결
  try connectClientSocket(withServAddr: &servAddr, &clientSocket)
  
  while true {
    // 4. send() 함수를 통해 클라이언트에서 입력한 메시지를 서버에 전달
    try sendMessageToServer(with: &clientSocket)
    // 5. recv() 함수를 통해 서버 측으로부터 받은 메시지를 클라이언트가 받음
    try receiveMessageFromServer(with: &clientSocket)
  }
  
  close(clientSocket)
}

//MARK: - Entry point
do {
  try TCPClientWithSwift()
} catch {
  print(error)
}
