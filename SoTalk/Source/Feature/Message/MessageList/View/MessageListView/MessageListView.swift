//
//  MessageListView.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/08.
//

import UIKit
import Combine

final class MessageListView: UIView {
  // MARK: - Properties
  var statusBarHeight: CGFloat!
  var naviBarHeight: CGFloat!
  var safeAreaBottomHeight: CGFloat!
  
  var tempUserName: String = ""
  
  private lazy var naviBar = MessageListNavigationBar(with: tempUserName)
  
  private lazy var naviBarBottomView = MessageListSearchAreaView()
  
  private let _groupView = GroupView()
  
  private let myGroupLabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .boldSystemFont(ofSize: Constant.MyGroupLabel.size)
    $0.textColor = Constant.MyGroupLabel.textColor
    $0.text = "My group"
  }
  
  private let addGroupButton: UIButton = UIButton().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    let text = "그룹 추가"
    let attrString = NSMutableAttributedString(string: text)
    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.white,
      .font: UIFont.systemFont(ofSize: 14)]
    attrString.addAttributes(
      attributes,
      range: NSRange(
        location: 0, length: text.count))
    $0.setAttributedTitle(
      attrString,
      for: .normal)
    $0.layer.cornerRadius = 21
    $0.backgroundColor = .Palette.primary
  }
  
  private let naviBGView = UIView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = UIColor.white
  }
  
  var groupSearchViewFrame: CGRect {
    naviBarBottomView.searchBarView.frame
  }
  
  var addGroupButtonTap: AnyPublisher<Void, Never> {
    addGroupButton
      .tap
      .subscribe(on: DispatchQueue.main)
      .map { [unowned self] in
        UIView.touchAnimate(addGroupButton)
      }
      .eraseToAnyPublisher()
  }
  
  var groupView: GroupView {
    return _groupView
  }
  
  // MARK: - Lifecycle
  private override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  convenience init(
    naviBarHeight: CGFloat,
    statusBarHeight: CGFloat,
    safeAreaBottomHeight: CGFloat,
    userName: String) {
    self.init(frame: .zero)
    self.naviBarHeight = naviBarHeight
    self.statusBarHeight = statusBarHeight
    self.safeAreaBottomHeight = safeAreaBottomHeight
    // 어차피 이건 userDefualts에서 가져올거.
    self.tempUserName = userName
    setupUI()
    naviBarBottomView.setShadow()
    setAddGroupButtonShadow()
    backgroundColor = UIColor(hex: "#F8F8FA")
    bringSubviewToFront(naviBGView)
    bringSubviewToFront(naviBar)
  }
}

// MARK: - Animation helper
extension MessageListView {
  private func hideMyGroupLabel() {
    myGroupLabel.center.y -= 15
    myGroupLabel.alpha = 0
  }
  
  private func showMyGroupLabel() {
    myGroupLabel.alpha = 1
    myGroupLabel.center.y += 15
  }
  
  private func hideGruopView() {
    _groupView.alpha = 0
  }
  
  private func showGroupView() {
    _groupView.alpha = 1
  }
  
  func hideSubviewsForAnimation() {
    naviBarBottomView.layoutIfNeeded()
    naviBarBottomView.hideMainTitle()
    naviBarBottomView.hideSearchBar()
    hideMyGroupLabel()
    hideGruopView()
    addGroupButton.isHidden = true
  }
  
  func animationSubviews() {
    UIView.animate(
      withDuration: 0.4,
      delay: 0.3,
      options: .curveEaseOut,
      animations: {
        self.naviBarBottomView.showMainTitle()
      }) { _ in
        UIView.animate(
          withDuration: 0.4,
          delay: 0.15,
          options: .curveEaseOut) {
            self.naviBarBottomView.showSearchBar()
          }
      }
    
    UIView.animate(
      withDuration: 0.2,
      delay: 1,
      options: .curveEaseIn,
      animations: {
        self.showMyGroupLabel()
      }) { _ in
        UIView.animate(
          withDuration: 0.2,
          delay: 0,
          options: .curveEaseOut,
          animations: {
            self.showGroupView()}) {_ in
              UIView.animate(
                withDuration: 0.2,
                delay: 1.0,
                options: .curveEaseOut) {
                  self.addGroupButton.isHidden = false
                }
            }
        
      }
  }
}

// MARK: - Helper
extension MessageListView {
  func setLayout(from superView: UIView) {
    superView.addSubview(self)
    NSLayoutConstraint.activate([
      leadingAnchor.constraint(equalTo: superView.leadingAnchor),
      trailingAnchor.constraint(equalTo: superView.trailingAnchor),
      topAnchor.constraint(equalTo: superView.topAnchor),
      bottomAnchor.constraint(equalTo: superView.bottomAnchor)])
  }
  
  func hideKeyboard() {
    naviBarBottomView.hideKeyboard()
  }
}

// MARK: - Private helper
extension MessageListView {
  func setAddGroupButtonShadow() {
    addGroupButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    addGroupButton.layer.shadowColor = UIColor.Palette.primary.cgColor
    addGroupButton.layer.shadowRadius = 6.0
    addGroupButton.layer.shadowOpacity = 0.3
    let width = addGroupButton.bounds.width
    let height = addGroupButton.bounds.height
    let rect = CGSize(width: width, height: height)
    let origin = CGPoint(
      x: addGroupButton.bounds.origin.x,
      y: addGroupButton.bounds.origin.y)
    
    addGroupButton.layer.shadowPath = UIBezierPath(
      roundedRect: CGRect(origin: origin, size: rect),
      cornerRadius: 6.0).cgPath
  }
}

// MARK: - LayoutSupport
extension MessageListView: LayoutSupport {
  func addSubviews() {
    _=[naviBGView,
       naviBar,
       _groupView,
       myGroupLabel,
       naviBarBottomView,
       addGroupButton]
      .map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[naviBGViewConstraints,
       messageListNavigationBarConstraints,
       groupViewConstraints,
       myGroupLabelConstraints,
       naviBottomViewConstraints,
       addGroupButtonConstraints]
      .map { NSLayoutConstraint.activate($0) }
  }
}

private extension MessageListView {
  var naviBGViewConstraints: [NSLayoutConstraint] {
    [naviBGView.leadingAnchor.constraint(equalTo: leadingAnchor),
     naviBGView.trailingAnchor.constraint(equalTo: trailingAnchor),
     naviBGView.topAnchor.constraint(equalTo: topAnchor),
     naviBGView.heightAnchor.constraint(equalToConstant: statusBarHeight + naviBarHeight)]
  }
  
  var messageListNavigationBarConstraints: [NSLayoutConstraint] {
    [naviBar.leadingAnchor.constraint(
      equalTo: leadingAnchor),
     naviBar.trailingAnchor.constraint(
      equalTo: trailingAnchor),
     naviBar.topAnchor.constraint(
      equalTo: topAnchor,
      constant: statusBarHeight),
     naviBar.heightAnchor.constraint(
      equalToConstant: naviBarHeight)]
  }
  
  var groupViewConstraints: [NSLayoutConstraint] {
    [_groupView.leadingAnchor.constraint(equalTo: leadingAnchor),
     _groupView.topAnchor.constraint(
      equalTo: myGroupLabel.bottomAnchor,
      constant: Constant.GroupView.spacing.top),
     _groupView.trailingAnchor.constraint(equalTo: trailingAnchor),
     _groupView.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: -safeAreaBottomHeight)]
  }
  
  var naviBottomViewConstraints: [NSLayoutConstraint] {
    [naviBarBottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
     naviBarBottomView.topAnchor.constraint(
      equalTo: naviBar.bottomAnchor),
     naviBarBottomView.trailingAnchor.constraint(
      equalTo: trailingAnchor),
     naviBarBottomView.heightAnchor.constraint(equalToConstant: naviBarBottomView.minimumHeight)]
  }
  
  var myGroupLabelConstraints: [NSLayoutConstraint] {
    [myGroupLabel.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: Constant.MyGroupLabel.spacing.leading),
     myGroupLabel.topAnchor.constraint(
      equalTo: naviBarBottomView.bottomAnchor,
      constant: Constant.MyGroupLabel.spacing.top)]
  }
  
  var addGroupButtonConstraints: [NSLayoutConstraint] {
    [addGroupButton.trailingAnchor.constraint(
      equalTo: trailingAnchor,
      constant: -Constant.AddGroupButton.spacing.trailing),
     addGroupButton.centerYAnchor.constraint(equalTo: myGroupLabel.centerYAnchor),
     addGroupButton.widthAnchor.constraint(equalToConstant: Constant.AddGroupButton.size.width),
     addGroupButton.heightAnchor.constraint(equalToConstant: Constant.AddGroupButton.size.height)]
  }
}
