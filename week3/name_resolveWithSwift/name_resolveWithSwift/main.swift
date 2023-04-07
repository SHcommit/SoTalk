//
//  main.swift
//  name_resolveWithSwift
//
//  Created by 양승현 on 2023/03/30.
//

import Foundation
import Cocoa

extension String: LocalizedError {
  public var errorDescription: String? { return self }
}

func getIPAddr(forUrl url: UnsafePointer<CChar>, addr: inout in_addr){
  ///인터넷 주소가 존재하는가?
  let host = gethostbyname(url).pointee
  print("host: \(NSString(utf8String: host.h_name)!)")
  let h_addr = host.h_addr_list.pointee
  memcpy(&addr, h_addr, Int(host.h_length))
}

func sizeof<T:FixedWidthInteger>(_ intType:T.Type) -> Int {
  return intType.bitWidth/UInt8.bitWidth
}


func getDomainName(_ addr: inout in_addr) -> NSString? {
  let host: hostent? = gethostbyaddr(
    &addr,
    UInt32(MemoryLayout<in_addr>.size),
    AF_INET).pointee
  
  guard let host = host else {
    return nil
  }
  
  return NSString(utf8String: &host.h_name.pointee)
}

func name_resolve() {
  var addr: in_addr = in_addr()
  getIPAddr(forUrl: "yahoo.com", addr: &addr)
  
  print("IP 주소 = \(NSString(utf8String: inet_ntoa(addr))!)")
  
  //MARK: - Convert IP to domain
  let name: NSString? = getDomainName(&addr)
  
  ///도메인 이름이 존재하는가?
  guard let name = name else {
    fatalError("internet address의 도메인 주소가 없습니다.")
  }
  
  print("도메인 주소 = \(name)")
}


name_resolve()
