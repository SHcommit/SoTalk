//
//  MessageListSideMenuView.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/08.
//

import UIKit

final class MessageListSideMenuView: UIView {
  // MARK: - Properties
  private let profile = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFill
    $0.layer.cornerRadius = Constant.Profile.size.width/2.0
    $0.backgroundColor = .lightGray
    $0.layer.shadowOffset = CGSize(width: 0.5, height: 1)
    $0.layer.shadowColor = UIColor(
      red: 0.251, green: 0.157, blue: 0.404, alpha: 0.05).cgColor
    $0.layer.shadowOpacity = 1
    $0.layer.shadowRadius = 10
    $0.sizeToFit()
    let rect = CGRect(
      x: $0.frame.origin.x,
      y: $0.frame.origin.y,
      width: Constant.Profile.size.width+0.5,
      height: Constant.Profile.size.height+1)
    $0.layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: 10).cgPath
  }
  
  private let nickname = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .boldSystemFont(ofSize: Constant.Nickname.textSize)
    $0.textColor = Constant.Nickname.textColor
    $0.text = "아리아나 그란데 말입니다"
    $0.sizeToFit()
  }
  
  private let name = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .systemFont(ofSize: Constant.Name.textSize)
    $0.textColor = Constant.Name.textColor
    $0.text = "기니디"
    $0.sizeToFit()
  }
  
  private let sideMenu = MessageListSideMenuLeftView()
  
  // MARK: - Lifecycle
  private override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  convenience init() {
    self.init(frame: .zero)
    backgroundColor = Constant.bgColor
    setupUI()
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    sideMenu.setShadow()
  }
}

// MARK: - Helper
extension MessageListSideMenuView {
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
    _=[profile, nickname, name, sideMenu].map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[profileConstraints,
       nicknameConstraints,
       nameConstraints,
       sideMenuConstraints]
      .map { NSLayoutConstraint.activate($0) }
  }
}

private extension MessageListSideMenuView {
  var profileConstraints: [NSLayoutConstraint] {
    [profile.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.Profile.spacing.top),
     profile.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: Constant.Profile.spacing.leading),
     profile.widthAnchor.constraint(equalToConstant: Constant.Profile.size.width),
     profile.heightAnchor.constraint(equalToConstant: Constant.Profile.size.height)]
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
