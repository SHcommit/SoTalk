//
//  SecretManager.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/04.
//

import Foundation

struct SecretManager {
  static let shared = SecretManager()
  
  let serverIp: String
  let serverPort: String
  
  private init() {
    let stored: [String: Any]? = Bundle.main.infoDictionary
    if let servAddr = stored?["ServerIp"] as? String {
      self.serverIp = servAddr
    } else {
      serverIp = ""
    }
    if let servPort = stored?["ServerPort"] as? String {
      self.serverPort = servPort
    } else {
      serverPort = ""
    }
  }
}
