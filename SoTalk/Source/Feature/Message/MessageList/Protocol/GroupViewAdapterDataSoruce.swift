//
//  GroupViewAdapterDataSoruce.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/30.
//

import Foundation

protocol GroupViewAdapterDataSource: AnyObject {
  var numberOfItems: Int { get }
  func cellItem(
    at index: Int
  ) -> GroupMessageRoomInfoModel
}
