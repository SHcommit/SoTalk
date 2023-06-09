//
//  AppSettings.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/09.
//

import Foundation

enum AppSetting {
  enum Key: String {
    case isLoggedIn
    case userInfo
  }
  
  static subscript(_ key: Key) -> Any? {
    get {
      UserDefaults.standard.value(forKey: key.rawValue)
    } set {
      UserDefaults.standard.setValue(newValue, forKey: key.rawValue)
    }
  }
  
  static func delete(_ key: Key) {
    UserDefaults.standard.removeObject(forKey: key.rawValue)
  }
}

// MARK: - Helper
extension AppSetting {
  static func boolValue(_ key: Key) -> Bool {
    if let value = AppSetting[key] as? Bool {
      return value
    }
    return false
  }
  
  static func stringValue(_ key: Key) -> String? {
    if let value = AppSetting[key] as? String {
      return value
    }
    return nil
  }
  
  static func intValue(_ key: Key) -> Int? {
    if let value = AppSetting[key] as? Int {
      return value
    }
    return nil
  }
}

// MARK: - User
extension AppSetting {
  static func setUser(with info: UserInfoModel) {
    let userInfo: [String: Any] = [
      "id": info.id,
      "name": info.name,
      "nickname": info.nickname,
      "profileUrl": info.profileUrl ?? ""
    ]
    AppSetting[.userInfo] = userInfo
  }
  
  static func getUser() -> UserInfoModel {
    guard
      let userInfo = AppSetting[.userInfo] as? [String: Any],
      let id = userInfo["id"] as? String,
      let name = userInfo["name"] as? String,
      let nickname = userInfo["nickname"] as? String
    else {
      return UserInfoModel(id: "", name: "", nickname: "", profileUrl: nil)
    }
    return UserInfoModel(id: id, name: name, nickname: nickname, profileUrl: userInfo["profileUrl"] as? String)
  }
  
  static func setUserProfile(with url: String) {
    let info = getUser()
    let userInfo: [String: Any] = [
      "id": info.id,
      "name": info.name,
      "nickname": info.nickname,
      "profileUrl": url]
    AppSetting[.userInfo] = userInfo
  }
  
  static func getUserProfileUrl(with url: String) -> String {
    return getUser().profileUrl ?? ""
  }
}
