//
//  MessageViewAdapter.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import UIKit

final class MessageViewAdapter: NSObject {
  // MARK: - Properties
  var dataSource: MessageViewControllerDataSource?
  
  // MARK: - Lifecycle
  init(
    collectionView: UICollectionView,
    dataSource: MessageViewControllerDataSource? = nil
  ) {
    super.init()
    self.dataSource = dataSource
    collectionView.delegate = self
    collectionView.dataSource = self
  }
}

// MARK: - UICollectionViewDataSource
extension MessageViewAdapter: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource?.numberOfItems ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: MessageCell.id,
        for: indexPath) as? MessageCell,
      let item = dataSource?.cellForRowAt(indexPath)
    else {
      return .init()
    }
    cell.configure(with: item)
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MessageViewAdapter: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    guard let item = dataSource?.cellForRowAt(indexPath)else {
      return CGSize(width: 50, height: 50)
    }
    let screenWidth = UIScreen.main.bounds.width
    var width = collectionView.bounds.width
    var height = 0.0
    var rect: CGRect
    let owner = AppSetting.getUser()
    
    guard item.userId == owner.id else {
      let messageContentViewOuterSpacing = MessageCell.Constant.Other.MessageContentView.spacing
      let messageContentViewInnerContentSpacing = MessageContentView.Constant.MessageLabel.spacing
      let messageContentViewInnerNameSpacing = MessageContentView.Constant.MessageLabel.spacing
      width -= (messageContentViewOuterSpacing.leading + messageContentViewOuterSpacing.trailing)
      width -= (messageContentViewInnerContentSpacing.leading + messageContentViewInnerContentSpacing.trailing)
      rect = CGRect(x: 0, y: 0, width: width, height: 50)
      let lb = UITextView(frame: rect).set {
        $0.font = .systemFont(ofSize: MessageContentView.Constant.MessageLabel.fontSize)
        $0.text = item.message
        $0.textAlignment = .natural
        $0.sizeToFit()
      }
      height += lb.bounds.height
      height += messageContentViewOuterSpacing.top + messageContentViewOuterSpacing.bottom
      height += messageContentViewInnerNameSpacing.top + messageContentViewInnerNameSpacing.bottom
      height += messageContentViewInnerContentSpacing.top + messageContentViewInnerContentSpacing.bottom
      if height < 50 {
        return CGSize(width: screenWidth, height: 50)
      }
      return CGSize(width: screenWidth, height: height)
    }
    
    let messageContentViewOuterSpacing = MessageCell.Constant.Me.MessageContentView.spacing
    width -= (messageContentViewOuterSpacing.leading + messageContentViewOuterSpacing.trailing)
    let messageContentViewInnerSpacing = MessageContentView.Constant.MessageLabel.spacing
    width -= (messageContentViewInnerSpacing.leading + messageContentViewInnerSpacing.trailing)
    
    rect = CGRect(x: 0, y: 0, width: width, height: 50)
    let lb = UITextView(frame: rect).set {
      $0.font = .systemFont(ofSize: MessageContentView.Constant.MessageLabel.fontSize)
      $0.text = item.message
      $0.textAlignment = .left
      $0.sizeToFit()
    }
    height += lb.bounds.height
    height += messageContentViewOuterSpacing.top + messageContentViewOuterSpacing.bottom
    height += messageContentViewInnerSpacing.top + messageContentViewInnerSpacing.bottom
    
    if height < 50 {
      return CGSize(width: screenWidth, height: height)
    }
    
    return CGSize(width: width, height: height)
  }
}
