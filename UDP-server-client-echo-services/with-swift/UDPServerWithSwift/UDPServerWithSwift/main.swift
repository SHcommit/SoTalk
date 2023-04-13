//
//  main.swift
//  UDPServerWithSwift
//
//  Created by 양승현 on 2023/04/13.
//

import Foundation

extension String: LocalizedError {
  public var errorDescription: String? { return self }
}

let Port = 9000
let MaxBuf = 4096

func udpServerWithSwift() throws {
  var servSocket: Int32 = socket(AF_INET, SOCK_DGRAM, 0)
  if servSocket == -1 { throw "DEBUG: Invalid server's socket" }
  
  var servAddr = sockaddr_in()
  var clientAddr = sockaddr()
  var clientAddrCount = socklen_t(MemoryLayout<sockaddr_in>.stride)
  
  servAddr.sin_family = sa_family_t(AF_INET)
  servAddr.sin_port = CFSwapInt16HostToBig(UInt16(Port))
  servAddr.sin_addr.s_addr = INADDR_ANY.bigEndian
  
  let bindResult = withUnsafePointer(to: &servAddr) {
    $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
      bind(servSocket, $0, socklen_t(MemoryLayout<sockaddr_in>.stride))
    }
  }
  guard bindResult != -1 else { throw "Failed to bind socket." }
  
  while true {
    print("DEBUG: 클라이언트로부터 데이터를 기다린다")
    
    var buffer = [UInt8](repeating: 0, count: MaxBuf)
    
    var ret = recvfrom(
      servSocket,
      &buffer,
      buffer.count,
      0,
      &clientAddr,
      &clientAddrCount)
    guard ret >= 0 else {
      throw "Invalid receive data fro client"
    }
    let data = Data(bytes: buffer, count: ret)
    if let str = String(data: data, encoding: .utf8) {
      print("read ===> \(str)")
    }else {
      throw "Error decoding receive"
    }
    
    ret = sendto(
      servSocket,
      buffer,
      ret,
      0,
      &clientAddr,
      clientAddrCount)
    
    guard ret >= 0 else {
      throw "Invalid receive data fro client"
    }
    
  }
}

do {
  try udpServerWithSwift()
} catch {
  print(error.localizedDescription)
}
