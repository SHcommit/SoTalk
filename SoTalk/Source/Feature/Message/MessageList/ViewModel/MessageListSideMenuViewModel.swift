//
//  MessageListSideMenuViewModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import UIKit

struct MessageListSideMenuViewModel {
  private let userRepository = UserRepositoryImpl()
}

// MARK: - Service
extension MessageListSideMenuViewModel {
  func fetchProfile(completionHandler: @escaping (UIImage?) -> Void) {
    guard
      let queryParamUrl = AppSetting.getUser().profileUrl
    else {
      completionHandler(nil)
      return
    }
    userRepository.fetchProfile(queryParamUrl) { data in
      completionHandler(UIImage(data: data))
    }
  }
}
