//
//  main.swift
//  IP_ADDRWithSwift
//
//  Created by 양승현 on 2023/03/30.
//

import Foundation

var servIP = "192.169.1.100"
//IP주소 출력
print("IP주소 = \(servIP)")
//inet_addr함수
print("IP 변환주소 0x\(inet_addr(servIP).hex)")

//inet_ntoa()
var temp: in_addr = in_addr(s_addr: inet_addr(servIP))
print("IP 변환주소 \(NSString(utf8String: inet_ntoa(temp))!)")
