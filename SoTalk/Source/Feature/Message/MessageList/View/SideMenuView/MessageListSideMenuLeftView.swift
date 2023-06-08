//
//  MessageListSideMenuLeftView.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/08.
//

import UIKit

final class MessageListSideMenuLeftView: UIView {
  
  // MARK: - Properties
  private let profile = IconAndLabelView()
  
  private let buyMeACoffee = IconAndLabelView()
  
  private let aboutUs = IconAndLabelView()
  
  private let logout = IconAndLabelView()
  
  private lazy var menuStackView: UIStackView = UIStackView(
    arrangedSubviews: [profile, buyMeACoffee, aboutUs, logout]).set {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = MessageListSideMenuView.Constant.lineSpacing
        $0.axis = .vertical
        $0.alignment = .top
        $0.distribution = .fillEqually
    }
  
  // MARK: - Lifecycle
  private override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = 24
    layer.maskedCorners = [
      .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  convenience init() {
    self.init(frame: .zero)
    backgroundColor = .white
    setShadow()
    configureSubviews()
    setupUI()
  }
  
  
}

// MARK: - Helper
extension MessageListSideMenuLeftView {
  func configureSubviews() {
    profile.configure(with: "Profile", UIImage(named: "profileIcon")!)
    buyMeACoffee.configure(with: "Buy me a coffee", UIImage(named: "buyMeACoffeeIcon")!)
    aboutUs.configure(with: "About us", UIImage(named: "aboutUsIcon")!)
    logout.configure(with: "Logout", UIImage(named: "LogoutIcon")!)
  }
  
  func showAnimation() {
    center.x += UIScreen.main.bounds.width
  }
  
  func hideAnimation() {
    center.x -= UIScreen.main.bounds.width
  }
  
  func setShadow() {
    layer.shadowOffset = CGSize(width: 4, height: 4)
    layer.shadowColor = UIColor.darkGray.cgColor
    layer.shadowColor = UIColor.white.cgColor
    layer.shadowOpacity = 0.48
    layer.shadowRadius = 16
    layer.masksToBounds = false
    let rect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width+4, height: bounds.height+4)
    layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: 16).cgPath
  }
}

// MARK: - LayoutSupport
extension MessageListSideMenuLeftView: LayoutSupport {
  func addSubviews() {
    addSubview(menuStackView)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      menuStackView.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: 20),
      menuStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      menuStackView.topAnchor.constraint(
        equalTo: topAnchor,
      constant: 20),
      menuStackView.bottomAnchor.constraint(
        equalTo: bottomAnchor,
      constant: -20)])
  }
}
