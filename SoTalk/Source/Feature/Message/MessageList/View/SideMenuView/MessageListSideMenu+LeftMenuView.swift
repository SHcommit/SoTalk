//
//  MessageListSideMenuLeftView.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/08.
//

import UIKit

final class MessageListSideMenuLeftMenuView: UIView {
  // MARK: - Constant
  private let StackViewSpacing = 20.0
  
  // MARK: - Properties
  private let profile = IconAndLabelView()

  private let buyMeACoffee = IconAndLabelView()
  
  private let aboutUs = IconAndLabelView()
  
  private let logout = IconAndLabelView()
  
  weak var delegate: MessageListSideMenuLeftMenuViewDelegate?
  
  private lazy var menuStackView: UIStackView = UIStackView(
    arrangedSubviews: [profile, buyMeACoffee, aboutUs, logout]).set {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.spacing = StackViewSpacing
        $0.axis = .vertical
        $0.alignment = .top
        $0.distribution = .fillEqually
    }
  
  // MARK: - Lifecycle
  private override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    isUserInteractionEnabled = true
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
    setEvent()
  }
}

// MARK: - Helper
extension MessageListSideMenuLeftMenuView {
  func configureSubviews() {
    profile.configure(with: "Edit profile", UIImage(named: "profileIcon")!)
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

// MARK: - Action
extension MessageListSideMenuLeftMenuView {
  @MainActor
  @objc func didTapEditProfile() {
    UIView.touchAnimationFromHalfToOriginAlphaValue(
      profile,
      duration: 0.5,
      delay: 0,
      options: [.curveEaseOut])
    delegate?.didTapEditProfile()
  }
  
  @MainActor
  @objc func didTapBuyMeACoffeePage() {
    UIView.touchAnimationFromHalfToOriginAlphaValue(
      buyMeACoffee,
      duration: 0.5,
      delay: 0,
      options: [.curveEaseOut])
    delegate?.didTapBuyMeACoffeePage()
  }
  
  @MainActor
  @objc func didTapAboutUsPage() {
    UIView.touchAnimationFromHalfToOriginAlphaValue(
      aboutUs,
      duration: 0.5,
      delay: 0,
      options: [.curveEaseOut])
    delegate?.didTapAboutUsPage()
  }
  
  @MainActor
  @objc func didTapLoginPage() {
    UIView.touchAnimationFromHalfToOriginAlphaValue(
      logout,
      duration: 0.15,
      delay: 0,
      options: [.curveEaseIn]
    ) { _ in
      self.delegate?.didTapLoginPage()
    }
  }
}

// MARK: - Private helepr
private extension MessageListSideMenuLeftMenuView {
  func setEvent() {
    _=[(profile, #selector(didTapEditProfile)),
       (buyMeACoffee, #selector(didTapBuyMeACoffeePage)),
       (aboutUs, #selector(didTapAboutUsPage)),
       (logout, #selector(didTapLoginPage))]
      .map {
        let tap = UITapGestureRecognizer(target: self, action: $1)
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tap)
      }
  }
}

// MARK: - LayoutSupport
extension MessageListSideMenuLeftMenuView: LayoutSupport {
  func addSubviews() {
    addSubview(menuStackView)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      menuStackView.leadingAnchor.constraint(
        equalTo: leadingAnchor,
        constant: 20),
      menuStackView.trailingAnchor.constraint(
        equalTo: trailingAnchor,
      constant: -10),
      menuStackView.topAnchor.constraint(
        equalTo: topAnchor,
      constant: 20),
      menuStackView.bottomAnchor.constraint(
        equalTo: bottomAnchor,
      constant: -20)])
  }
}
