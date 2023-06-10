//
//  CreatingGroupBottomSheetViewModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/10.
//

import Foundation

final class CreatingGroupBottomSheetViewModel {
  private let groupRepository = GroupMessageRepositoryImpl()
  private var groupInfoModel = CreatingGroupInfoModel()
}

// MARK: - Helper
extension CreatingGroupBottomSheetViewModel {
  func setGroupName(with text: String) {
    groupInfoModel.groupName = text
  }
  
  func setGroupInfoImageData(with imageData: Data) {
    groupInfoModel.imageData = imageData
  }
}

// MARK: - Service
extension CreatingGroupBottomSheetViewModel {
  func addNewGroupRoom(completionHandler: @escaping () -> Void) {
    let userId = AppSetting.getUser().id
    let requestDTO = NewMessageGroupRequestDTO(
      groupName: groupInfoModel.groupName,
      userId: userId)
    groupRepository.addNewMessageGroup(with: requestDTO) { groupId in
      let gruopProfileRequestDTO = GroupProfileUploadRequestDTO(
        groupId: groupId,
        imageData: self.groupInfoModel.imageData)
      self.groupRepository.uploadGroupProfile(with: gruopProfileRequestDTO) { url in
        print("DEBUG: Successfully get url. \(url)")
        completionHandler()
      }
    }
  }
}
