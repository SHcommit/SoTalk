//
//  MessageCellViewModel.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/11.
//

import UIKit

protocol MessageCellViewModelDelegate: AnyObject {
  func setProfile(with image: UIImage?)
  func setNickname(with nickname: String)
}

final class MessageCellViewModel {
  private let userRepository = UserRepositoryImpl()
  weak var delegate: MessageCellViewModelDelegate?
}

// MARK: - Service
extension MessageCellViewModel {
  func fetchProfile(
    _ url: String,
    completionHandler: @escaping (UIImage?) -> Void
  ) {
    userRepository.fetchProfile(url) {
      completionHandler(UIImage(data: $0))
    }
  }
  
  func fetchUserInfo(with id: String) {
    let requestDTO = UserIdSearchRequestDTO(id: id)
    userRepository.fetchUserInfo(requestDTO) { [weak self] info in
      self?.delegate?.setNickname(with: info.nickname)
      guard let url = info.profileUrl else { return }
      self?.fetchProfile(url) { [weak self] image in
        self?.delegate?.setProfile(with: image)
      }
    }
  }
}
