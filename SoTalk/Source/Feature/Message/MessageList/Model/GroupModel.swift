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
  let gorupImage: UIImage?
  
  init(groupId: Int = -1, groupName: String = "None", gorupImage: UIImage? = nil) {
    self.groupId = groupId
    self.groupName = groupName
    self.gorupImage = gorupImage
  }
}
