//
//  ChatListModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/30.
//

import UIKit

struct GroupModel {
  let groupId: Int
  let groupName: String
  let groupImage: UIImage?
  let groupMemberTotalCount: Int
  
  init(groupId: Int = -1,
       groupName: String = "None",
       groupImage: UIImage? = nil,
       groupMemberTotalCount: Int = 1
  ) {
    self.groupId = groupId
    self.groupName = groupName
    self.groupImage = groupImage
    self.groupMemberTotalCount = groupMemberTotalCount
  }
}
