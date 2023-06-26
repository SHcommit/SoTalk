//
//  SignUpRepositoryImpl.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/05.
//

import Foundation

struct SignUpRepositoryImpl: SignUpRepository {
  typealias Endpoints = AuthenticationAPIEndpoints
  
  private let provider = SessionProviderImpl()
  
  func signUp(_ user: SignUpRequestDTO, completionHandler: @escaping (String) -> Void) {
    let endpoint = Endpoints.shared.signUp(with: user)
    provider.request(with: endpoint) { result in
      switch result {
      case .success(let response):
        completionHandler(response.id)
      case .failure(let error):
        print("DEBUG: \(error.localizedDescription)")
      }
    }
  }
  
  func duplicateCheck(_ userId: UserIdSearchRequestDTO, completionHandler: @escaping (Bool) -> Void) {
    
    let endpoint = Endpoints.shared.duplicateCheck(with: userId)
    provider.request(with: endpoint) { result in
      switch result {
      case .success(let response):
        completionHandler(response.isRegisteredUser)
      case .failure(let error):
        print("DEBUG: \(error.localizedDescription)")
      }
    }
  }
}
