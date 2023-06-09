//
//  MessageListViewModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/30.
//

import UIKit

final class MessageListViewModel {
  // MARK: - Properties
  private var groupModel: [GroupModel]?
  private let userRepository = UserRepositoryImpl()
  
  init(model: [GroupModel]? = nil) {
    self.groupModel = MockGroupModel().mockData()
  }
}

// MARK: - GroupViewAdapterDataSource
extension MessageListViewModel: GroupViewAdapterDataSource {
  var numberOfItems: Int {
    groupModel?.count ?? 0
  }
  
  func cellItem(at index: Int) -> GroupModel {
    guard let item = groupModel?[index] else {
      return .init()
    }
    return item
  }
}

// MARK: - Service
extension MessageListViewModel {
  func uploadProfile(with imageData: Data) {
    let userId = AppSetting.getUser().id
    let requestDTO = ProfileUploadRequestDTO(userId: userId, imageData: imageData)
    userRepository.uploadProfile(requestDTO) { url in
      var userInfo = AppSetting.getUser()
      userInfo.profileUrl = url
      AppSetting.setUser(with: userInfo)
    }
  }
  
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
