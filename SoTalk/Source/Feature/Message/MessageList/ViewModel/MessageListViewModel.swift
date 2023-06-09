//
//  MessageListViewModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/30.
//

import Foundation

final class MessageListViewModel {
  // MARK: - Properties
  private var groupModel: [GroupModel]?
  private let userRepository = UserRepositoryImpl()
  
  init(model: [GroupModel]? = nil) {
    self.groupModel = MockGroupModel().mockData()
  }
}

// MARK: - GroupViewAdapterDataSource
extension MessageListViewModel: GroupViewAdapterDataSource {
  var numberOfItems: Int {
    groupModel?.count ?? 0
  }
  
  func cellItem(at index: Int) -> GroupModel {
    guard let item = groupModel?[index] else {
      return .init()
    }
    return item
  }
}
