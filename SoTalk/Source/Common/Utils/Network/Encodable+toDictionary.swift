//
//  Encodable+toDictionary.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/04.
//

import Foundation

extension Encodable {
  func toDictionary() -> [String: Any]? {
    do {
      let encoder = JSONEncoder()
      let jsonData = try encoder.encode(self)
      if let dict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
        return dict
      }
    } catch {
      print("DEBUG: Error encoding JSON \(error)")
    }
    return nil
  }
}
