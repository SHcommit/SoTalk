//
//  LoginRepositoryImpl.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/05.
//

import Foundation

struct LoginRepositoryImpl: LoginRepository {
  typealias Endpoints = AuthenticationAPIEndpoints
  private let provider = ServiceProviderImpl()
  
  func login(_ user: LoginRequestDTO, completionHandler: @escaping (String) -> Void) {
    let endpoint = Endpoints.shared.Login(with: user)
    provider.request(with: endpoint) { result in
      switch result {
      case .success(let response):
        completionHandler(response.id)
      case .failure(let error):
        print("DEBUG: \(error.localizedDescription)")
      }
    }
  }
}
