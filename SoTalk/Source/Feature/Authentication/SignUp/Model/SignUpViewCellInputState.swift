//
//  SignUpViewCellState.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/29.
//

import Foundation

enum SignUpViewCellInputState: CaseIterable {
  case name
  case nickname
  case id
  case password
  case signUpEnd
  
  static var count: Int {
    return self.allCases.count
  }
  
  static subscript(index: Int) -> SignUpViewCellInputState {
    return Self.allCases[index]
  }
  
  var value: Int {
    switch self {
    case .name: return 0
    case .nickname: return 1
    case .id: return 2
    case .password: return 3
    case .signUpEnd: return 4
    }
  }
}
