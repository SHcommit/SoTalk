//
//  UDPSocketProvider.swift
//  testUDPSocketClient
//
//  Created by 양승현 on 2023/04/14.
//

import Foundation

protocol UDPSocketServiceCase {
  typealias Socket = Int32
}

extension UDPSocketServiceCase {
  static func setupServAddr(
    withIP ip: String,
    withPort port: Int, _ sockaddr: inout sockaddr_in
  ) {
    sockaddr.sin_family = sa_family_t(AF_INET)
    sockaddr.sin_port = CFSwapInt16HostToBig(UInt16(port))
    sockaddr.sin_addr.s_addr = inet_addr(ip)
  }
  
  func sendToAnotherUDPSocket(
    from socket: Socket,
    to sockAddr: inout sockaddr_in,
    withData data: NSData
  ) -> Int {
    return withUnsafePointer(to: &sockAddr) {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { serv in
        sendto(
          socket,
          data.bytes,
          data.count,
          0,
          serv,
          socklen_t(MemoryLayout<sockaddr_in>.size))
      }
    }
  }
  
  func receiveFromOtherSocket(
    from sockAddr: inout sockaddr_in,
    to socket: Socket,
    bufSize: Int
  ) throws -> ([UInt8],Int) {
    var buffer = [UInt8](repeating: 0, count: bufSize)
    var addrLen = socklen_t(MemoryLayout<sockaddr_in>.size)
    
    let res = withUnsafeMutablePointer(to: &sockAddr) {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { serverPtr in
        recvfrom(socket, &buffer, buffer.count, 0, serverPtr, &addrLen)
      }
    }
    guard res >= 0 else {
      throw "Invalid receive data from client"
    }
      
    return (buffer,res)
  }
  
  func convertDataToString(_ binaryData: [UInt8], _ count: Int) throws -> String {
    let receivedData = Data(bytes: binaryData, count: count)
    guard let str = String(data: receivedData, encoding: .utf8) else {
      throw "Error decoding received data"
    }
    return str
  }
  
  func checkSocketInfo(_ socket: Socket) throws {
    if socket == -1 { throw "Invaild socket instance" }
  }
  
}

struct UDPSocketService: UDPSocketServiceCase {
  
  private let Port = 9000
  private let MaxBuf = 4096
  private let ip: String
  
  var clientSock: Socket
  var servAddr: sockaddr_in
  
  init(
    clientSock: Socket = socket(AF_INET, SOCK_DGRAM, 0),
    servAddr: sockaddr_in,
    ip: String
  ) {
    self.clientSock = clientSock
    self.servAddr = servAddr
    self.ip = ip
    UDPSocketService.setupServAddr(withIP: ip, withPort: Port, &self.servAddr)
  }
  
  static func echoServiceInit() -> UDPSocketService {
    return UDPSocketService(servAddr: sockaddr_in(), ip: "127.0.0.1")
  }
  
}

