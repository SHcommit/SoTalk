//
//  GroupChatSearch.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/29.
//

import UIKit

extension GroupChatSearch {
  enum Constant {
    static let cornerRadius = 17.0
    enum Icon {
      static let size = CGSize(width: 14, height: 14)
      static let spacing: UISpacing = .init(leading: 24)
      static let name = "search"
      static let color = UIColor.Palette.primaryHalf
    }
    
    enum TextField {
      static let spacing: UISpacing = .init(leading: 11, trailing: 25)
      static let size = 14.0
      static let textColor = UIColor.Palette.primary
      static let placeholderColor = UIColor.Palette.primaryHalf
    }
  }
}

final class GroupChatSearch: UIView {
  // MARK: - Properties
  private let textField = UITextField().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .systemFont(ofSize: Constant.TextField.size)
    $0.textColor = Constant.TextField.textColor
    let comment = "그룹 이름을 검색하세요."
    let placeholderAttrStr = NSMutableAttributedString(
      string: comment)
    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: Constant.TextField.placeholderColor,
      .font: UIFont.systemFont(ofSize: Constant.TextField.size)]
    placeholderAttrStr.addAttributes(
      attributes,
      range: NSRange(location: 0, length: comment.count))
    $0.attributedPlaceholder = placeholderAttrStr
  }
  
  private let icon = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.contentMode = .scaleAspectFill
    $0.image = UIImage(named: Constant.Icon.name)?.setColor(Constant.TextField.textColor)
  }
  
  private let searchButton = AuthenticationButton(with: "Search")
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = Constant.cornerRadius
    layer.masksToBounds = true
    backgroundColor = .Palette.searchBG
    textField.delegate = self
  }
  
  convenience init() {
    self.init(frame: .zero)
    setupUI()
    initInputAccessoryView()
    setInputAccessoryViewWithButton()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private helpers
extension GroupChatSearch {
  func initInputAccessoryView() {
    // constant
    let height: CGFloat = 75.0
    let origin: CGPoint = .init(x: 0, y: -300)
    let size: CGSize = .init(
      width: UIScreen.main.bounds.width,
      height: height)
    
    let containerView = UIView(
      frame: CGRect(origin: origin, size: size))
        
    textField.inputAccessoryView = containerView
  }
  
  var accessoryView: UIView? {
    textField.inputAccessoryView
  }
  
  func setInputAccessoryViewWithButton() {
    searchButton.setInputAccessoryViewLayout(
      from: accessoryView,
      spacing: .init(leading: 24, trailing: 24))
  }
  
  func hideKeyboard() {
    textField.resignFirstResponder()
  }
}

extension GroupChatSearch: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    textField.resignFirstResponder()
  }
}

// MARK: - LayoutSupport
extension GroupChatSearch: LayoutSupport {
  func addSubviews() {
    _=[icon, textField].map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[iconConstraints, textFieldConstratins].map { NSLayoutConstraint.activate($0) }
  }
}

private extension GroupChatSearch {
  var iconConstraints: [NSLayoutConstraint] {
    [icon.leadingAnchor.constraint(
      equalTo: leadingAnchor,
      constant: Constant.Icon.spacing.leading),
     icon.centerYAnchor.constraint(equalTo: centerYAnchor),
     icon.widthAnchor.constraint(
      equalToConstant: Constant.Icon.size.width),
     icon.heightAnchor.constraint(
      equalToConstant: Constant.Icon.size.height)]
  }
  
  var textFieldConstratins: [NSLayoutConstraint] {
    [textField.leadingAnchor.constraint(
      equalTo: icon.trailingAnchor,
      constant: Constant.TextField.spacing.leading),
     textField.trailingAnchor.constraint(
      equalTo: trailingAnchor,
      constant: -Constant.TextField.spacing.trailing),
     textField.centerYAnchor.constraint(equalTo: centerYAnchor)]
  }
}
