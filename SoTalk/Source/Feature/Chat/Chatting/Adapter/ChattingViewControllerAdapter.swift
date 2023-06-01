//
//  ChattingViewControllerAdapter.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import UIKit

final class ChattingViewControllerAdapter: NSObject {
  // MARK: - Properties
  var dataSource: ChattingViewControllerDataSource?
  
  // MARK: - Lifecycle
  init(
    collectionView: UICollectionView,
    dataSource: ChattingViewControllerDataSource? = nil
  ) {
    super.init()
    self.dataSource = dataSource
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

// MARK: - UICollectionViewDataSource
extension ChattingViewControllerAdapter: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource?.numberOfItems ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: ChattingCell.id,
        for: indexPath) as? ChattingCell,
      let item = dataSource?.cellForRowAt(indexPath)
    else {
      return .init()
    }
    cell.configure(with: item)
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ChattingViewControllerAdapter: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    guard let item = dataSource?.cellForRowAt(indexPath)else {
      return CGSize(width: 50, height: 50)
    }
    let screenWidth = collectionView.bounds.width
    let rect = CGRect(x: 0, y: 0, width: screenWidth-8-8-8-50, height: 50)
    let lb = UITextView(frame: rect).set {
      $0.font = .systemFont(ofSize: 15)
      $0.text = item.comment
    }
    lb.sizeToFit()
    if lb.bounds.height > 50 {
      return CGSize(
        width: screenWidth,
        height: lb.bounds.height)
    }
    return CGSize(width: screenWidth, height: 50)
  }
}
