//
//  MessageListSideMenuView.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/08.
//

import UIKit

final class MessageListSideMenuView: UIView {
  // MARK: - Properties
  private let profileView = UIView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.shadowOffset = CGSize(width: 0.5, height: 1)
    $0.layer.shadowColor = UIColor(
      red: 0.251, green: 0.157, blue: 0.404, alpha: 0.05).cgColor
    $0.layer.shadowOpacity = 1
    $0.layer.shadowRadius = 10
    $0.layer.cornerRadius = Constant.ProfileView.size.width/2.0
    $0.sizeToFit()
    let rect = CGRect(
      x: $0.frame.origin.x,
      y: $0.frame.origin.y,
      width: Constant.ProfileView.size.width+0.5,
      height: Constant.ProfileView.size.height+1)
    $0.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: 10).cgPath
  }
  
  private let profile = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = Constant.ProfileView.size.width/2.0
    $0.backgroundColor = .lightGray
    $0.clipsToBounds = true
  }
  
  private let nickname = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .boldSystemFont(ofSize: Constant.Nickname.textSize)
    $0.textColor = Constant.Nickname.textColor
    $0.text = "미정"
    $0.sizeToFit()
  }
  
  private let name = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .systemFont(ofSize: Constant.Name.textSize)
    $0.textColor = Constant.Name.textColor
    $0.text = "익명"
    $0.sizeToFit()
  }
  
  private let sideMenu = MessageListSideMenuLeftMenuView()
  
  weak var delegate: MessageListSideMenuLeftMenuViewDelegate? {
    get {
      sideMenu.delegate
    } set {
      sideMenu.delegate = newValue
    }
  }
  
  private let vm = MessageListSideMenuViewModel()
  
  // MARK: - Lifecycle
  private override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    isUserInteractionEnabled = true
    profileView.addSubview(profile)
    NSLayoutConstraint.activate([
      profile.leadingAnchor.constraint(
        equalTo: profileView.leadingAnchor),
      profile.trailingAnchor.constraint(
        equalTo: profileView.trailingAnchor),
      profile.topAnchor.constraint(equalTo: profileView.topAnchor),
      profile.bottomAnchor.constraint(
        equalTo: profileView.bottomAnchor)])
    setUserInfo()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  convenience init() {
    self.init(frame: .zero)
    backgroundColor = Constant.bgColor
    setupUI()
    setUserInfo()
    
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    sideMenu.setShadow()
  }
}

// MARK: - Helper
extension MessageListSideMenuView {
  func setUserInfo() {
    let userInfo = AppSetting.getUser()
    DispatchQueue.main.async {
      self.nickname.text = userInfo.nickname
      self.name.text = userInfo.name
      
    }
    vm.fetchProfile { image in
      guard let image = image else { return }
      DispatchQueue.main.async {
        self.profile.image = image
      }
    }
  }
  
  func setLayout(from superView: UIView) {
    superView.addSubview(self)
    NSLayoutConstraint.activate([
      leadingAnchor.constraint(equalTo: superView.leadingAnchor),
      trailingAnchor.constraint(equalTo: superView.trailingAnchor),
      topAnchor.constraint(equalTo: superView.topAnchor),
      bottomAnchor.constraint(equalTo: superView.bottomAnchor)])
  }
    
  func showLeftMenuWithAnim() {
    sideMenu.showAnimation()
    showProfileArea()
  }
  
  func hideLeftMenuWithAnim() {
    sideMenu.hideAnimation()
  }
  
  func showProfileArea() {
    _=[profile, nickname, name]
      .map {
        $0.center.x += UIScreen.main.bounds.width
      }
  }
  
  func hideProfileArea() {
    _=[profile, nickname, name]
      .map {
        $0.center.x -= UIScreen.main.bounds.width
        $0.alpha = 0
      }
  }
}

// MARK: - LayoutSupport
extension MessageListSideMenuView: LayoutSupport {
  func addSubviews() {
    _=[profileView, nickname, name, sideMenu].map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[profileViewConstraints,
       nicknameConstraints,
       nameConstraints,
       sideMenuConstraints]
      .map { NSLayoutConstraint.activate($0) }
  }
}

private extension MessageListSideMenuView {
  var profileViewConstraints: [NSLayoutConstraint] {
    [profileView.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.ProfileView.spacing.top),
     profileView.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: Constant.ProfileView.spacing.leading),
     profileView.widthAnchor.constraint(equalToConstant: Constant.ProfileView.size.width),
     profileView.heightAnchor.constraint(equalToConstant: Constant.ProfileView.size.height)]
  }
  
  var nicknameConstraints: [NSLayoutConstraint] {
    [nickname.topAnchor.constraint(
      equalTo: profile.bottomAnchor,
      constant: Constant.Nickname.spacing.top),
     nickname.centerXAnchor.constraint(equalTo: profile.centerXAnchor)]
  }
  
  var nameConstraints: [NSLayoutConstraint] {
    [name.topAnchor.constraint(
      equalTo: nickname.bottomAnchor,
      constant: Constant.Name.spacing.top),
     name.centerXAnchor.constraint(equalTo: profile.centerXAnchor)]
  }
  
  var sideMenuConstraints: [NSLayoutConstraint] {
    [sideMenu.leadingAnchor.constraint(equalTo: leadingAnchor),
     sideMenu.topAnchor.constraint(
      equalTo: name.bottomAnchor,
      constant: Constant.SideMenu.spacing.top),
     sideMenu.widthAnchor.constraint(
      equalToConstant: Constant.SideMenu.width),
     sideMenu.heightAnchor.constraint(equalToConstant: 250)]
  }
}
