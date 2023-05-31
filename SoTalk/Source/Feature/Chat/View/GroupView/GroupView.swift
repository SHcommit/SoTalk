//
//  GroupView.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/30.
//

import UIKit

extension GroupView {
  enum Constant {
    static let itemSize = CGSize(width: 210, height: 300)
  }
}

final class GroupView: UICollectionView {
  
  // MARK: - Initialization
  private override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.itemSize = Constant.itemSize
    self.init(frame: .zero, collectionViewLayout: layout)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .yellow
    self.register(
      GroupViewCell.self,
      forCellWithReuseIdentifier: GroupViewCell.id)
  }
}
