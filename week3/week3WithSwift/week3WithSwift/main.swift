//
//  main.swift
//  week3WithSwift
//
//  Created by 양승현 on 2023/03/30.
//

import Foundation
import CFNetwork
import CoreFoundation

var x: UInt16 = 0x1234
var x2: UInt16
var y: UInt32 = 0x12345678
var y2: UInt32

extension UnsignedInteger {
  var hex: String {
    return String(self, radix: 16, uppercase: true)
  }
}

print("호스트 바이트 -> 네트워크 바이트")
x2 = x.bigEndian
y2 = y.bigEndian
print("0x\(x.hex) -> 0x\(x2.hex)")
print("0x\(y.hex) -> 0x\(y2.hex)")

print("네트워크 바이트 -> 호스트 바이트")
x2 = x2.bigEndian
y2 = y2.bigEndian
print("0x\(x.hex) -> 0x\(x2.hex)")
print("0x\(y.hex) -> 0x\(y2.hex)")
