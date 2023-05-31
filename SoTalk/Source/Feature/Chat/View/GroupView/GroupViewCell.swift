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
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .systemGray
    layer.cornerRadius = 10
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension GroupViewCell {
  func configure(with data: String) {
    backgroundColor = .cyan
  }
}
