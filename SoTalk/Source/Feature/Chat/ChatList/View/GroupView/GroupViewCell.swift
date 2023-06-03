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
  private let imageView: UIImageView = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = cornerRadius
    $0.clipsToBounds = true
    $0.contentMode = .scaleAspectFill
    $0.backgroundColor = .lightGray
  }
  
  private let bluredView: UIView = {
    let blur = UIBlurEffect(style: .light)
    let bluredView = UIVisualEffectView(effect: blur)
    bluredView.translatesAutoresizingMaskIntoConstraints = false
    bluredView.layer.cornerRadius = GroupViewCell.cornerRadius
    bluredView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    return bluredView
  }()
  
  private let groupName = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .boldSystemFont(ofSize: 20)
    $0.numberOfLines = 2
    $0.clipsToBounds = true
    $0.layer.cornerRadius = GroupViewCell.cornerRadius
    $0.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    $0.backgroundColor = .none
    $0.text = "Empty"
  }
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    layer.cornerRadius = GroupViewCell.cornerRadius
    setupUI()
    setBlurFromImageView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helper
extension GroupViewCell {
  func configure(with data: GroupModel) {
    backgroundColor = .white
    setShadow()
  }
}

// MARK: - Private helper
extension GroupViewCell {
  @MainActor
  func setImageView(with image: UIImage) {
    imageView.image = image
  }
  
  func setGroupName(with title: String) {
    groupName.text = title
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
  
  func setBlurFromImageView() {
    imageView.addSubview(bluredView)
    NSLayoutConstraint.activate([
      bluredView.centerXAnchor.constraint(
        equalTo: groupName.centerXAnchor),
      bluredView.centerYAnchor.constraint(
        equalTo: groupName.centerYAnchor),
      bluredView.widthAnchor.constraint(
        equalToConstant: groupName.bounds.width),
      bluredView.heightAnchor.constraint(
        equalToConstant: groupName.bounds.height - groupName.bounds.width)])
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
      contentView.bringSubviewToFront(groupName)
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
      imageView.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor)]
  }
  
  var groupNameConstraints: [NSLayoutConstraint] {
    [groupName.leadingAnchor.constraint(
      equalTo: contentView.leadingAnchor),
     groupName.trailingAnchor.constraint(
      equalTo: contentView.trailingAnchor),
     groupName.bottomAnchor.constraint(
      equalTo: contentView.bottomAnchor),
     groupName.heightAnchor.constraint(
      equalToConstant: contentView.bounds.height-contentView.bounds.width)]
  }
}
