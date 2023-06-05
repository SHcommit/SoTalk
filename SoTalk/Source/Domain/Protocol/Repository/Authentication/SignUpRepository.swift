//
//  SignUpRepository.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/05.
//

protocol SignUpRepository: Repository {
  func signUp(_ user: SignUpRequestDTO, completionHandler: @escaping (String) -> Void)
  func duplicateCheck(_ userId: UserIdSearchRequestDTO, completionHandler: @escaping (Bool) -> Void)
}
