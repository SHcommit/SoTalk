//
//  SecretManager.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/04.
//

import Foundation

struct SecretManager {
  static let shared = SecretManager()
  
  let serverAddress: String
  
  private init() {
    let stored: [String: Any]? = Bundle.main.infoDictionary
    if let servAddr = stored?["API_KEY"] as? String {
      self.serverAddress = servAddr
    } else {
      serverAddress = ""
    }
  }
  
}
