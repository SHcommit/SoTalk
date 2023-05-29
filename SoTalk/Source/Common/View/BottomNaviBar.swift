//
//  BottomNaviBar.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/29.
//

import UIKit

extension BottomNaviBar {
  // MARK: - Constant
  enum Constant {
    static let width: CGFloat = UIScreen.main.bounds.width
    
    static let cornerRadius: CGFloat = 32.73
    
    static let shadowOpacity: Float = 1
    
    static let shadowOffset: CGSize = CGSize(width: 0, height: 10.91)
    
    static let shadowRadius: CGFloat = 4.0
    
    static let shadowColor: CGColor = UIColor(
      red: 0.251, green: 0.157, blue: 0.404, alpha: 0.05).cgColor
    
    enum MainTitle {
      static let fontSize: CGFloat = 30.0
      static let spacing: UISpacing = .init(leading: 31, top: 32)
    }
    
    enum SearchBar {
      static let spacing: UISpacing = .init(
        leading: 32, top: 24, trailing: 32, bottom: 24)
      
      static let size = {
        let height = 42.0
        let width = UIScreen.main.bounds.width - 25*2.0
        return CGSize(width: width, height: height)
      }()
    }
    
  }
}

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
  
  private var minimumHeight: CGFloat {
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
    layer.cornerRadius = Constant.cornerRadius
    layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    layer.shadowOpacity = Constant.shadowOpacity
    layer.shadowOffset = Constant.shadowOffset
    layer.shadowRadius = Constant.shadowRadius
    layer.shadowColor = Constant.shadowColor
    layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: Constant.cornerRadius).cgPath
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
  func layoutFrom(rootView view: UIView) {
    layoutSubviews()
    view.addSubview(self)
    NSLayoutConstraint.activate([
      leadingAnchor.constraint(equalTo: view.leadingAnchor),
      topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor),
      trailingAnchor.constraint(
        equalTo: view.trailingAnchor),
      heightAnchor.constraint(equalToConstant: minimumHeight)])
  }
  
  func hideKeyboard() {
    searchBar.hideKeyboard()
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
