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
    // 로그인 사용자의 프로필 url과 유효한지 ( 사용자인가? 다른사람의 채팅인가 )
    // 여기서 url로 사용자 일치 여불르 비교하면안되겠다. 이미지 안올릴경우.....
    // 일단 임시로 userName으로 해보자
    if data.username == "홍길동" {
      messageSenderState = .me
      profile.isHidden = true
    }
    
    if messageSenderState != .me {
      setProfile(with: data.profileImageUrl)
    }
    
    let messageContentModel = MessageContentModel(name: data.username, message: data.comment)
    messageContentView.configure(with: messageContentModel, state: messageSenderState)
    
    if !isSetupUICalled {
      isSetupUICalled = true
      setupUI()
    }
  }
}

// MARK: - Private helper
private extension MessageCell {
  func setProfile(with url: String) {
    // url 다운받은후에 이미지 적용
    // profile.image = ...
  }
  
  func setMessageContentView(with model: MessageContentModel) {
    messageContentView.configure(with: model, state: messageSenderState)
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
