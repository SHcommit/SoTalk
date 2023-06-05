//
//  LoginRepository.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/05.
//

import Foundation

protocol LoginRepository: Repository {
  func login(_ user: LoginRequestDTO, completionHandler: @escaping (String) -> Void)
}
