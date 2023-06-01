//
//  CommentModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import Foundation

struct CommentModel {
  let uid: String
  let comment: String
  let username: String
  let profileImageUrl: String
}

struct UploadCommentModel {
  let comment: String
  let postId: String
  let user: UserModel
}
