//
//  ChattingCell.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import UIKit

final class ChattingCell: UICollectionViewCell {
  // MARK: - Constant
  static let id: String = String(describing: ChattingCell.self)
  
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .brown
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Helpers
extension ChattingCell {
  func configure(with data: CommentModel) {
    
  }
}
