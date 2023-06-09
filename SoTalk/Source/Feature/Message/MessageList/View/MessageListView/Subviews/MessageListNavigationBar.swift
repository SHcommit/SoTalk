//
//  MessageListLeftNaviItem.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/29.
//

import UIKit
import Lottie

protocol MessageListNavigationBarDelegate: AnyObject {
  func didTapProfile()
}

final class MessageListNavigationBar: UIView {
  // MARK: - Properties
  private let bottleView = LottieAnimationView(name: Constant.BottleView.imageName).set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.loopMode = .loop
    $0.contentMode = .scaleAspectFit
  }
  
  private let userNameLabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.numberOfLines = 2
    $0.textAlignment = .left
  }
  
  private lazy var profile = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = Constant.MyProfile.size.width/2.0
    $0.clipsToBounds = true
    $0.backgroundColor = .lightGray
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapProfile))
    $0.isUserInteractionEnabled = true
    $0.addGestureRecognizer(tap)
  }
  
  weak var delegate: MessageListNavigationBarDelegate?
  
  // MARK: - Initialization
  private override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .clear
    clipsToBounds = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init() {
    self.init(frame: .zero)
    setUserNickname()
    setupUI()
    bottleView.play()
  }
}

// MARK: - Action
extension MessageListNavigationBar {
  @objc func tapProfile() {
    delegate?.didTapProfile()
  }
}

// MARK: - Helpers
extension MessageListNavigationBar {
  /// 이름 변경할 수 도 있으니까 side->홈으로 올 때 이 함수 호출해야 합니다.
  func setUserNickname() {
    let name = AppSetting.getUser().nickname
    let attrString = NSMutableAttributedString(
      string: "Hello,\n\(name)님!")
    let hiAttrStr: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(
        ofSize: Constant.userNameLabel.fontSize),
      .foregroundColor: UIColor.Palette.primaryHalf]
    
    let userNameAttrStr: [NSAttributedString.Key: Any] = [
      .font: UIFont.boldSystemFont(
        ofSize: Constant.userNameLabel.fontSize),
      .foregroundColor: UIColor.Palette.primary]
    _=[
      (hiAttrStr,
       NSRange(location: 0, length: 6)),
      (userNameAttrStr,
       NSRange(location: 7, length: name.count+2))]
      .map { attrString.addAttributes($0, range: $1) }
    
    userNameLabel.attributedText = attrString
  }
  
  @MainActor
  func setProfile(_ image: UIImage) {
    profile.image = image
  }
}

// MARK: - LayoutSupport
extension MessageListNavigationBar: LayoutSupport {
  func addSubviews() {
    _=[bottleView, userNameLabel, profile].map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[menuViewConstraints, userNameLabelConstraints, profileConstraints]
      .map { NSLayoutConstraint.activate($0) }
  }
}

private extension MessageListNavigationBar {
  var menuViewConstraints: [NSLayoutConstraint] {
    [bottleView.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: Constant.BottleView.spacing.leading),
     bottleView.centerYAnchor.constraint(equalTo: centerYAnchor),
     bottleView.heightAnchor.constraint(
      equalToConstant: Constant.BottleView.size.height),
     bottleView.widthAnchor.constraint(
      equalToConstant: Constant.BottleView.size.width)]
  }
  
  var userNameLabelConstraints: [NSLayoutConstraint] {
    [userNameLabel.leadingAnchor.constraint(
      equalTo: bottleView.trailingAnchor,
      constant: Constant.userNameLabel.spacing.leading),
     userNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)]
  }
  
  var profileConstraints: [NSLayoutConstraint] {
    [profile.trailingAnchor.constraint(
      equalTo: trailingAnchor,
      constant: -Constant.MyProfile.spacing.trailing),
     profile.widthAnchor.constraint(
      equalToConstant: Constant.MyProfile.size.width),
     profile.heightAnchor.constraint(
      equalToConstant: Constant.MyProfile.size.height),
     profile.centerYAnchor.constraint(
      equalTo: centerYAnchor)]
  }
}
