//
//  SignUpViewAdapter.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/28.
//

import UIKit

final class SignUpViewAdapter: NSObject {
  // MARK: - Properties
  weak var dataSource: SignUpViewAdapterDataSource?
  weak var delegate: SignUpViewCellDelegate?
  
  // MARK: - Initialization
  init(
    dataSource: SignUpViewAdapterDataSource? = nil,
    delegate: SignUpViewCellDelegate?) {
      self.dataSource = dataSource
      self.delegate = delegate
    }
}

// MARK: - UICollectionViewDataSource
extension SignUpViewAdapter: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return dataSource?.numberOfItems ?? 0
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: SignUpViewCell.id,
        for: indexPath) as? SignUpViewCell,
      let item = dataSource?.cellItem(at: indexPath.row) else {
      return .init()
    }
    cell.configure(with: item, indexPath: indexPath)
    cell.delegate = delegate
    return cell
  }
}

// MARK: - UIC
extension SignUpViewAdapter: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return collectionView.bounds.size
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt indexPath: IndexPath
  ) {
    guard let cell = cell as? SignUpViewCell else { return }
    cell.showKeyboard()
  }
}
