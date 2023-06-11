//
//  SocketUtils.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/11.
//

import Foundation

struct SocketUtils {
  private init() { }
  static let shared = SocketUtils()
  
  func strToJosn(_ text: String, sendKey: SocketJsonKeyType) -> String {
    let dict = ["\(sendKey.rawValue)": "\(text)"]
    if let dictToData = try? JSONSerialization.data(withJSONObject: dict),
       var dictJsonStr = String(data: dictToData, encoding: .utf8) {
      dictJsonStr.append("\n")
      print("DEBUG: Successful converted dictionary to json type's string. \(dictJsonStr)")
      return dictJsonStr
    }
    return ""
  }
  
  func ckeckError(_ res: Int, actionType: SocketActionType) throws {
    switch actionType {
    case .send:
      guard res != -1 else { throw SocketError.FailedToSendMessage }
      print("DEBUG: Successfully send \(res) bytes to server.")
    case .recv:
      guard res != -1 else { throw SocketError.FailedToRecvMessage }
      print("DEBUG: Successfully recv \(res) bytes from server.")
    }
  }
  
  func dataToDictionary(_ data: Data) throws -> [String: Any] {
    let json = try JSONSerialization.jsonObject(with: data, options: [])
    guard let dictionary = json as? [String: Any] else {
      throw SocketError.FailedToConvertDataToDict
    }
    return dictionary
  }
  
  func jsonStrToBytes(_ string: String) -> Data {
    return string.data(using: .utf8) ?? Data()
  }
  
}
