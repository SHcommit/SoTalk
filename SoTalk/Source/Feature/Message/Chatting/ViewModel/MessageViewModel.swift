//
//  MessageViewModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import UIKit

final class MessageViewModel {
  // MARK: - Properties
  private let groupRepository = GroupMessageRepositoryImpl()
  
  // 데이터가 받아지면 collectionView reloadData gogo
  @Published var messageData: [CommentModel] = []
  
  var groupId: Int
  
  // 들어올 때 채팅방
  init(groupId: Int) {
    self.groupId = groupId
  }
}

extension MessageViewModel: MessageViewControllerDataSource {
  var numberOfItems: Int {
    messageData.count
  }
  
  func cellForRowAt(_ indexPath: IndexPath) -> CommentModel {
    return messageData[indexPath.row]
  }

}

// MARK: - Helper
extension MessageViewModel {
  func addMesasge(with data: CommentModel) {
    messageData.append(data)
  }
}

// MARK: - Service
extension MessageViewModel {
  func fetchAllMessages() {
    groupRepository.fetchAllMessageInSpecificGroup(
      with: GroupIdRequestDTO(groupId: groupId)
    ) { data in
      self.messageData = data.map {
        return CommentModel(
          userId: $0.userId,
          message: $0.message,
          sendTime: $0.sendTime)
      }
    }
  }
  
  func fetchGroupPort(completionHandler: @escaping (Int) -> Void) {
    let userId = AppSetting.getUser().id
    let requestDTO = GroupJoinRequestDTO(groupId: groupId, userId: userId)
    groupRepository.joinGroup(with: requestDTO) { groupPort in
      completionHandler(groupPort)
    }
  }
}
