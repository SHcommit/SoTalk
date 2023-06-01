//
//  BottomNaviBar.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/29.
//

import UIKit

final class BottomNaviBar: UIView {
  // MARK: - Properties
  private let mainTitle = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .boldSystemFont(ofSize: Constant.MainTitle.fontSize)
    $0.numberOfLines = 2
    $0.textAlignment = .left
    var paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.07
    let attrStr = NSMutableAttributedString(
      string: "What Group \ndo you want to join?")
    let textAttr: [NSAttributedString.Key: Any] = [
      .paragraphStyle: paragraphStyle,
      .foregroundColor: UIColor.Palette.primary]
    attrStr.addAttributes(
      textAttr,
      range: NSRange(location: 0, length: attrStr.string.count))
    $0.attributedText = attrStr
    $0.sizeToFit()
  }
  
  var minimumHeight: CGFloat {
    let mainTitleHeightWithtopSpacing = Constant.MainTitle.spacing
      .top + mainTitle.bounds.height
    let searchHeightWithTopBottomSpacing = Constant.SearchBar.spacing
      .top + Constant.SearchBar.spacing
      .bottom + Constant.SearchBar.size
      .height
    return mainTitleHeightWithtopSpacing + searchHeightWithTopBottomSpacing
  }
  
  private let searchBar = GroupChatSearch()
  
  var searchBarView: GroupChatSearch {
    searchBar
  }
  
  // MARK: - Initialization
  private override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .white
    setupUI()
  }
  
  convenience init() {
    self.init(frame: .zero)
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension BottomNaviBar {  
  func hideKeyboard() {
    searchBar.hideKeyboard()
  }
  
  func setShadow() {
    guard let superview = superview else { return }
    superview.layoutIfNeeded()
    layer.cornerRadius = 24
    layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    layer.shadowOpacity = 1
    layer.shadowOffset = CGSize(width: 0, height: 2)
    layer.shadowRadius = 12
    layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.06).cgColor
    let shadowRect = CGRect(
      x: bounds.origin.x,
      y: bounds.origin.y,
      width: bounds.width,
      height: bounds.height + 2)
    layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
  }
}

// MARK: - Animation helper
extension BottomNaviBar {
  
  func hideMainTitle() {
    mainTitle.alpha = 0
    mainTitle.center.y -= 30
  }
  
  func hideSearchBar() {
    searchBar.alpha = 0
    searchBar.center.y -= 30
  }
  
  func showMainTitle() {
    mainTitle.alpha = 1
    mainTitle.center.y += 30
  }
  
  func showSearchBar() {
    searchBar.alpha = 1
    searchBar.center.y += 30
  }
}

// MARK: - LayoutSupport
extension BottomNaviBar: LayoutSupport {
  func addSubviews() {
    _=[mainTitle, searchBar].map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[mainTitleConstraints, searchBarConstraints].map { NSLayoutConstraint.activate($0) }
  }
}

// MARK: - LayoutSupport constraints
private extension BottomNaviBar {
  var mainTitleConstraints: [NSLayoutConstraint] {
    [mainTitle.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: Constant.MainTitle.spacing.leading),
     mainTitle.topAnchor.constraint(
      equalTo: topAnchor,
      constant: Constant.MainTitle.spacing.top)]
  }
  
  var searchBarConstraints: [NSLayoutConstraint] {
    [searchBar.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: Constant.SearchBar.spacing.leading),
     searchBar.trailingAnchor.constraint(
      equalTo: trailingAnchor,
      constant: -Constant.SearchBar.spacing.trailing),
     searchBar.heightAnchor.constraint(
      equalToConstant: Constant.SearchBar.size.height),
     searchBar.topAnchor.constraint(
      equalTo: mainTitle.bottomAnchor,
      constant: Constant.SearchBar.spacing.top),
     searchBar.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: -Constant.SearchBar.spacing.bottom)]
  }
}
