//
//  MessageViewControllerDataSource.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import Foundation

protocol MessageViewControllerDataSource {
  var numberOfItems: Int { get }
  func cellForRowAt(_ indexPath: IndexPath) -> CommentModel
}
