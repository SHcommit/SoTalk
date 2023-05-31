//
//  GroupViewAdapter.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/30.
//

import UIKit

final class GroupViewAdapter: NSObject {
  weak var dataSource: GroupViewAdapterDataSource?
  
  init(dataSource: GroupViewAdapterDataSource? = nil) {
    self.dataSource = dataSource
  }
}

extension GroupViewAdapter: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    dataSource?.numberOfItems ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: GroupViewCell.id,
        for: indexPath) as? GroupViewCell,
      let _ = dataSource?.cellItem(at: indexPath.row)
    else {
      return .init()
    }
    cell.configure(with: "hi")
    return cell
  }
}

extension GroupViewAdapter: UICollectionViewDelegate {
  
}
