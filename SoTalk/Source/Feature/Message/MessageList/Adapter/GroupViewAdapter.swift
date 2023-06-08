//
//  GroupViewAdapter.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/30.
//

import UIKit

final class GroupViewAdapter: NSObject {
  weak var dataSource: GroupViewAdapterDataSource?
  weak var delegate: GroupViewAdapterDelegate?
  
  init(
    dataSource: GroupViewAdapterDataSource? = nil,
    collectionView: GroupView? = nil,
    delegate: GroupViewAdapterDelegate?
  ) {
    super.init()
    self.dataSource = dataSource
    self.delegate = delegate
    collectionView?.delegate = self
    collectionView?.dataSource = self
  }
}

// MARK: - UICollectionViewDataSource
extension GroupViewAdapter: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    dataSource?.numberOfItems ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: GroupViewCell.id,
        for: indexPath) as? GroupViewCell,
      let item = dataSource?.cellItem(at: indexPath.row)
    else {
      return .init()
    }
    cell.configure(with: item)
    return cell
  }
}

// MARK: - UICollectionViewDelegate
extension GroupViewAdapter {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    print("ahahah")
    guard let cell = collectionView.cellForItem(at: indexPath) as? GroupViewCell else {
      return
    }
    UIView.animate(withDuration: 0.2, animations: {
      cell.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
    }) { [weak self] _ in
      self?.delegate?.didSelectItemAt(indexPath)
      cell.transform = .identity
    }

  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GroupViewAdapter: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return GroupView.Constant.itemSize
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    return 0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return GroupView.Constant.interLineSpacing
  }
}

// MARK: - UIScrollViewDelegate
extension GroupViewAdapter {
  func scrollViewWillEndDragging(
    _ scrollView: UIScrollView,
    withVelocity velocity: CGPoint,
    targetContentOffset: UnsafeMutablePointer<CGPoint>
  ) {
    let itemSize = GroupView.Constant.itemSize.width
    let interItemSpacing = GroupView.Constant.interLineSpacing
    let itemAndInterItemSpacingSize = itemSize + interItemSpacing
    var offset = targetContentOffset.pointee
    var idx = 0.0
    if offset.x > GroupView.Constant.edgeInset {
      idx = round(
        (offset.x - GroupView
          .Constant
          .edgeInset)/itemAndInterItemSpacingSize)
    }
    if idx == 0 {
      offset = CGPoint(x: idx*itemSize - GroupView.Constant.edgeInset, y: 0.0)
    } else {
      offset = CGPoint(x: idx*itemSize, y: 0)
    }
    targetContentOffset.pointee = offset
  }
}
