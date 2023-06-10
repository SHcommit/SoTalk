//
//  MessageListViewModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/30.
//

import UIKit

final class MessageListViewModel {
  // MARK: - Properties
  private var groupModel: [GroupMessageRoomInfoModel]?
  private let userRepository = UserRepositoryImpl()
  private let groupRepository = GroupMessageRepositoryImpl()
  
  init() {
    // self.groupModel = MockGroupModel().mockData()
  }
}

// MARK: - GroupViewAdapterDataSource
extension MessageListViewModel: GroupViewAdapterDataSource {
  var numberOfItems: Int {
    groupModel?.count ?? 0
  }
  
  func cellItem(at index: Int) -> GroupMessageRoomInfoModel {
    guard let item = groupModel?[index] else {
      return .init(groupId: -1, groupName: "", memberCount: 0)
    }
    return item
  }
}

// MARK: - Service
extension MessageListViewModel {
  func uploadProfile(with imageData: Data, completionHandler: @escaping () -> Void) {
    let userId = AppSetting.getUser().id
    let requestDTO = ProfileUploadRequestDTO(userId: userId, imageData: imageData)
    userRepository.uploadProfile(requestDTO) { url in
      var userInfo = AppSetting.getUser()
      userInfo.profileUrl = url
      AppSetting.setUser(with: userInfo)
      completionHandler()
    }
  }
  
  func fetchProfile(
    completionHandler: @escaping (UIImage?) -> Void
  ) {
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
  
  func fetchAllGroupMessageRoomList(
    _ completionHandler: @escaping () -> Void
  ) {
    groupRepository.fetchAllGroupList {
      print(self.groupModel)
      self.groupModel = $0
      completionHandler()
    }
  }
}
