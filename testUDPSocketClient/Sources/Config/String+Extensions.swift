//
//  String+Extensions.swift
//  testUDPSocketClient
//
//  Created by 양승현 on 2023/04/14.
//

import Foundation

extension String: LocalizedError {
  public var errorDescription: String? { return self }
}
