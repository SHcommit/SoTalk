//
//  GroupViewCell.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/30.
//

import UIKit

final class GroupViewCell: UICollectionViewCell {
  // MARK: - Constant
  static let id = String(describing: GroupViewCell.self)
  static let cornerRadius = 24.0
  
  // MARK: - Properties
  let imageView: UIImageView = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = cornerRadius
    $0.clipsToBounds = true
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    $0.contentMode = .scaleAspectFill
    $0.backgroundColor = .lightGray
  }
  
  let groupName = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .boldSystemFont(ofSize: 14)
    $0.numberOfLines = 2
    $0.text = "Title is empty\n Hahaah"
  }
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    layer.cornerRadius = GroupViewCell.cornerRadius
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension GroupViewCell {
  func configure(with data: GroupModel) {
    backgroundColor = .white
    setShadow()
  }
  
  func setShadow() {
    layer.shadowOpacity = 1
    layer.shadowOffset = CGSize(width: 1, height: 1)
    layer.shadowRadius = 12
    layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.06).cgColor
    let shadowRect = CGRect(
      x: contentView.frame.origin.x,
      y: contentView.frame.origin.y,
      width: contentView.frame.width + 3,
      height: contentView.frame.height + 3)
    layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
  }
}

// MARK: - LayoutSupport
extension GroupViewCell: LayoutSupport {
  func addSubviews() {
    _=[imageView, groupName].map { contentView.addSubview($0) }
  }
  
  func setConstraints() {
    _=[imageViewConstraints, groupNameConstraints].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

private extension GroupViewCell {
  var imageViewConstraints: [NSLayoutConstraint] {
    return [
      imageView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor),
      imageView.topAnchor.constraint(
        equalTo: contentView.topAnchor),
      imageView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor),
      imageView.heightAnchor.constraint(
        equalToConstant: contentView.bounds.width)
    ]
  }
  
  var groupNameConstraints: [NSLayoutConstraint] {
    [groupName.leadingAnchor.constraint(
      equalTo: contentView.leadingAnchor),
     groupName.topAnchor.constraint(
      equalTo: imageView.bottomAnchor),
     groupName.trailingAnchor.constraint(
      equalTo: contentView.trailingAnchor),
     groupName.bottomAnchor.constraint(
      equalTo: contentView.bottomAnchor)]
  }
}
