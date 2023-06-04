//
//  MessageListViewModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/30.
//

import Foundation

final class MessageListViewModel {
  // MARK: - Properties
  var model: [GroupModel]?
  
  init(model: [GroupModel]? = nil) {
    self.model = MockGroupModel().mockData()
  }
}

// MARK: - GroupViewAdapterDataSource
extension MessageListViewModel: GroupViewAdapterDataSource {
  var numberOfItems: Int {
    model?.count ?? 0
  }
  
  func cellItem(at index: Int) -> GroupModel {
    guard let item = model?[index] else {
      return .init()
    }
    return item
  }
}
