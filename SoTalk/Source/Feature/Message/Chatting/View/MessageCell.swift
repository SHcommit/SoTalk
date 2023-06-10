//
//  MessageCell.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import UIKit

final class MessageCell: UICollectionViewCell {
  
  // MARK: - Properties
  private let profile = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .lightGray
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = Constant.Other.Profile.size.width/2
    $0.clipsToBounds = true
  }
  
  private let messageContentView = MessageContentView()
  
  private var isSetupUICalled = false
  
  private var messageSenderState: MessageSenderState = .other
  
  private let vm = MessageCellViewModel()
        
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helper
extension MessageCell {
  func configure(with data: CommentModel) {
    let owner = AppSetting.getUser()
    if data.userId == owner.id {
      messageSenderState = .me
      profile.isHidden = true
    }
    
    let inputModel = MessageContentInfoModel(
      message: data.message,
      sendTime: data.sendTime)
    messageContentView.configure(with: inputModel, state: messageSenderState)
    
    if !isSetupUICalled {
      isSetupUICalled = true
      setupUI()
    }
  }
}

// MARK: - MessageCellViewModelDelegate
extension MessageCell: MessageCellViewModelDelegate {
  func setProfile(with image: UIImage?) {
    guard messageSenderState != .me else {
      return
    }
    DispatchQueue.main.async {
      self.profile.image = image
    }
  }
  
  func setNickname(with nickname: String) {
    DispatchQueue.main.async {
      self.messageContentView.setNameLabel(with: nickname)
    }
  }
}

// MARK: - LayoutSupport
extension MessageCell: LayoutSupport {
  func addSubviews() {
    var subviews: [UIView] = [messageContentView]
    if messageSenderState == .other { subviews.append(profile) }
    _=subviews.map { contentView.addSubview($0) }
  }
  
  func setConstraints() {
    var subviewConstraints = [messageContentViewConstraints]
    if messageSenderState == .other { subviewConstraints.append(profileCosntraints) }
    _=subviewConstraints.map { NSLayoutConstraint.activate($0) }
  }
}

// MARK: - Layout supprot helper
private extension MessageCell {
  var profileCosntraints: [NSLayoutConstraint] {
    [profile.leadingAnchor.constraint(
      equalTo: contentView.leadingAnchor,
      constant: Constant.Other.Profile.spacing.leading),
     profile.topAnchor.constraint(
      equalTo: contentView.topAnchor,
      constant: Constant.Other.Profile.spacing.top),
     profile.widthAnchor.constraint(
      equalToConstant: Constant.Other.Profile.size.width),
     profile.heightAnchor.constraint(
      equalToConstant: Constant.Other.Profile.size.height)]
  }
  
  var messageContentViewConstraints: [NSLayoutConstraint] {
    var constraints = [
      messageContentView.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: Constant.Me.MessageContentView.spacing.top),
      messageContentView.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor,
        constant: -Constant.Me.MessageContentView.spacing.bottom)]
    
    switch messageSenderState {
    case .me:
      constraints.append(contentsOf: [
        messageContentView.leadingAnchor.constraint(
          equalTo: contentView.leadingAnchor,
          constant: Constant.Me.MessageContentView.spacing.leading),
        messageContentView.trailingAnchor.constraint(
          equalTo: contentView.trailingAnchor,
          constant: -Constant.Me.MessageContentView.spacing.trailing)
      ])
    case .other:
      constraints.append(contentsOf: [
        messageContentView.leadingAnchor.constraint(
          equalTo: profile.trailingAnchor,
          constant: Constant.Other.MessageContentView.spacing.leading),
        messageContentView.trailingAnchor.constraint(
          equalTo: contentView.trailingAnchor,
          constant: -Constant.Other.MessageContentView.spacing.trailing)
      ])
    }
    
    return constraints
  }
}
