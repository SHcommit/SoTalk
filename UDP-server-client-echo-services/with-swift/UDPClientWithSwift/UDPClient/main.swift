//
//  main.swift
//  UDPClient
//
//  Created by 양승현 on 2023/04/13.
//

import Foundation

extension String: LocalizedError {
  public var errorDescription: String? { return self }
}

let Port = 9000
let MaxBuf = 4096

func udpClientWithSwift() throws {
  
  var clientSocket: Int32 = socket(AF_INET, SOCK_DGRAM, 0)
  if clientSocket == -1 { throw "DEBUG: Invalid client's socket" }
  
  var servAddr = sockaddr_in()
  servAddr.sin_family = sa_family_t(AF_INET)
  servAddr.sin_port = CFSwapInt16HostToBig(UInt16(Port))
  servAddr.sin_addr.s_addr = inet_addr("127.0.0.1")
  
  
  while true {
    // 이경우 애초에 readLine()은 한글의 자음과 모음이 분리되서 받아진다. 그래서 뭘 하든 에러가 발생한다.
    // 유니코드 스칼라값으로 받아봤지만 다시 한글로 변환했을 때 텍스트가 깨진다.
    guard let text = readLine()?.precomposedStringWithCompatibilityMapping else {
      throw "DEBUG: Invalid input text"
    }
    let data = text.data(using: .utf8)! as NSData
    var res = withUnsafePointer(to: &servAddr) {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { serverPtr in
        sendto(clientSocket , data.bytes, data.count, 0, serverPtr, socklen_t(MemoryLayout<sockaddr_in>.size))
      }
    }
    
    if res == -1 {
      throw "DEBUG: Error sending data to server"
    }
    
    print("sendto ===> \(text)")
    
    var buffer = [UInt8](repeating: 0, count: MaxBuf)
    var addrLen = socklen_t(MemoryLayout<sockaddr_in>.size)
    
    res = withUnsafeMutablePointer(to: &servAddr) {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { serverPtr in
        recvfrom(clientSocket, &buffer, buffer.count, 0, serverPtr, &addrLen)
      }
    }
    guard res >= 0 else {
      throw "Invalid receive data fro client"
    }
    
    let receivedData = Data(bytes: buffer, count: res)
    if let str = String(data: receivedData, encoding: .utf8) {
      print("recvfrom ===> \(str)")
    }else {
      throw "Error decoding receive"
    }
    
  }
  
}

do{
  try udpClientWithSwift()
} catch {
  
  print(error.localizedDescription)
}
