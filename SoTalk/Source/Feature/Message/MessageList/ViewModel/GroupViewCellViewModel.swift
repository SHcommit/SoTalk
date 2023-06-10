//
//  GroupViewCellViewModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import UIKit

struct GroupViewCellViewModel {
  private var item: GroupMessageRoomInfoModel
  
  private let groupRepository = GroupMessageRepositoryImpl()
  
  var groupId: Int {
    item.groupId
  }
  
  init(
    item: GroupMessageRoomInfoModel) {
    self.item = item
  }
}

// MARK: - Service
extension GroupViewCellViewModel {
  func fetchGroupProfile(
    completionHandler: @escaping (UIImage?) -> Void
  ) {
    guard let url = item.profileUrl else {
      print("DEBUG: GroupView profile url is nil.")
      return
    }
    groupRepository
      .fetchGroupProfile(with: url) { data in
        completionHandler(UIImage(data: data))
      }
  }
}
