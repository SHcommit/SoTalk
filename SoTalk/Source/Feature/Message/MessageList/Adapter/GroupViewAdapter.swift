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
    guard let cell = collectionView.cellForItem(at: indexPath) as? GroupViewCell else {
      return
    }
    UIView.animate(withDuration: 0.2, animations: {
      cell.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
    }) { [weak self] _ in
      // 여기서 이제 특정 cell이 소유즁인 groupId를 보내야함.
      guard let groupId = cell.groupId else { return }
      self?.delegate?.didSelectItemAt(indexPath,groupId: groupId)
      UIView.animate(withDuration: 0.2) {
        cell.transform = .identity
      }
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
    
    let itemWidth = GroupView.Constant.itemSize.width
    let interItemSpacing = GroupView.Constant.interLineSpacing
    
    var collectionViewInset = GroupView.Constant.edgeInset
    
    let contentWidth = scrollView.contentSize.width
    let maximumScrollableWidth = contentWidth
      - scrollView.bounds.width
    let fixexContentW = contentWidth - collectionViewInset*2.0
    let msWidth = maximumScrollableWidth
    let cellAndSpacingArea = itemWidth + interItemSpacing
    var offset = targetContentOffset.pointee
    let idx = round(
      offset.x *
      fixexContentW /
      msWidth /
      cellAndSpacingArea)
    guard let n = dataSource?.numberOfItems else { return }
    if Int(idx) == n {
      collectionViewInset *= 2
    }
    offset = CGPoint(
      x: idx*cellAndSpacingArea-collectionViewInset,
      y: 0.0)

    targetContentOffset.pointee = offset
  }
}
