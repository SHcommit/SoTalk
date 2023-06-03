//
//  SecretManager.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/04.
//

import Foundation

struct SecretManager {
  static let shared = SecretManager()
  
  let apiKey: String
  let test: String
  
  private init() {
    let stored: [String: Any]? = Bundle.main.infoDictionary
    if let keyPath = stored?["API_KEY"] as? String {
      self.apiKey = keyPath
      print(keyPath)
    } else {
      apiKey = ""
    }
    if let test = stored?["Test"] as? String {
      self.test = test
      print(test)
    } else {
      test = ""
    }
  }
  
}
