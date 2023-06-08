//
//  KeyChainWrapper.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/07.
//

import Foundation

class KeychainWrapper {
  func storeGenericPasswordFor(
    account: String,
    service: String,
    password: String
  ) throws {
    guard let passwordData = password.data(using: .utf8) else {
      throw KeychainWrapperError(type: .badData)
    }
    
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: account,
      kSecAttrService as String: service,
      kSecValueData as String: passwordData]
    
    let status = SecItemAdd(query as CFDictionary, nil)
    switch status {
    case errSecSuccess:
      break
    case errSecDuplicateItem:
      break
    default:
      throw KeychainWrapperError.init(status: status, type: .servicesError)
    }
  }
  
  func getGenericPasswordFor(
    account: String,
    service: String
  ) throws -> String {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: account,
      kSecAttrService as String: service,
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecReturnAttributes as String: true,
      kSecReturnData as String: true]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status != errSecSuccess else {
      throw KeychainWrapperError(status: status, type: .servicesError)
    }
    guard
      let existingItem = item as? [String: Any],
      let valueData = existingItem[kSecValueData as String] as? Data,
      let value = String(data: valueData, encoding: .utf8)
    else {
      throw KeychainWrapperError(
        type: .unableToConvertToString)
    }
    return value
  }
  
  func updateGenericPasswordFor(
    account: String,
    service: String,
    password: String
  ) throws {
    guard let passwordData = password.data(using: .utf8) else {
      print("DEBUG: Error. Cant' converting password as data")
      return
    }
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: account,
      kSecAttrService as String: service]
    let attributes: [String: Any] = [
      kSecValueData as String: passwordData]
    let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
    guard status != errSecItemNotFound else {
      throw KeychainWrapperError(
        message: "Matching item not found",
        type: .itemNotFound)
    }
    
    guard status == errSecSuccess else {
      throw KeychainWrapperError(status: status, type: .servicesError)
    }
  }
  
  func deleteGenericPasswordFor(
    account: String,
    service: String
  ) throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: account,
      kSecAttrService as String: service]
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw KeychainWrapperError(status: status, type: .servicesError)
    }
  }
}
