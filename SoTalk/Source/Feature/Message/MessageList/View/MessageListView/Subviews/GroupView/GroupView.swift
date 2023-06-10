//
//  GroupView.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/30.
//

import UIKit

extension GroupView {
  enum Constant {
    static let itemSize = CGSize(width: 250, height: 375)
    static let edgeInset = 50.0
    static let interLineSpacing = 50.0
  }
}

final class GroupView: UICollectionView {
  // MARK: - Initialization
  private override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    isUserInteractionEnabled = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = Constant.itemSize
    self.init(frame: .zero, collectionViewLayout: layout)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .none
    decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.45)
    
    contentInset = UIEdgeInsets(
      top: 0,
      left: GroupView.Constant.interLineSpacing,
      bottom: 0,
      right: GroupView.Constant.interLineSpacing)
    showsHorizontalScrollIndicator = false
    self.register(
      GroupViewCell.self,
      forCellWithReuseIdentifier: GroupViewCell.id)
  }
}
