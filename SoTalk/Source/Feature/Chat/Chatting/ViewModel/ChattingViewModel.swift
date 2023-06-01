//
//  ChattingViewModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import UIKit

final class ChattingViewModel {
  // MARK: - Properties
  let data = [
    CommentModel(uid: "1", comment: "2", username: "3", profileImageUrl: "4"),
    CommentModel(uid: "5", comment: "6", username: "7", profileImageUrl: "8")]
}

extension ChattingViewModel: ChattingViewControllerDataSource {
  var numberOfItems: Int {
    data.count
  }
  
  func cellForRowAt(_ indexPath: IndexPath) -> CommentModel {
    return data[indexPath.row]
  }

}
