//
//  ChattingSendInputAccessoryViewDelegate.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import Foundation

protocol CommentSendInputAccessoryViewDelegate: AnyObject {
  func inputView(
    wantsToUploadComment comment: String,
    completionHandler: @escaping (Result<Void, Error>) -> Void)
}
