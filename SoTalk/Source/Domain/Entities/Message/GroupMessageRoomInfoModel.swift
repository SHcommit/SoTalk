//
//  GroupMessageInfoModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import Foundation

//
//struct CommentModel {
//  // 사용자 id
//  let userId: String
//  let message: String
//  let sendTime: String
//  var profileImageUrl: String?
//}

struct GroupMessageRoomInfoModel {
  var groupId: Int
  var groupName: String
  var memberCount: Int
  var profileUrl: String?
}
