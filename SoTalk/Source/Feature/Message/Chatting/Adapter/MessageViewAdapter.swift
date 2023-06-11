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
    var messageContentViewWidth = collectionView.bounds.width
    var height = 0.0
    var rect: CGRect
    let owner = AppSetting.getUser()
    if item.userId == owner.id {
      let messageContentViewOuterSpacing = MessageCell.Constant.Me.MessageContentView.spacing
      messageContentViewWidth -= (messageContentViewOuterSpacing.leading + messageContentViewOuterSpacing.trailing)
      let messageContentViewInnerSpacing = MessageContentView.Constant.MessageLabel.spacing
      messageContentViewWidth -= (messageContentViewInnerSpacing.leading + messageContentViewInnerSpacing.trailing)
      
      rect = CGRect(x: 0, y: 0, width: messageContentViewWidth, height: 60)
      let messageLabel = UILabel(frame: rect).set {
        $0.font = .systemFont(ofSize: MessageContentView.Constant.MessageLabel.fontSize)
        $0.text = item.message
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.sizeToFit()
      }
      height += messageLabel.bounds.height + 3
      height += messageContentViewOuterSpacing.top + messageContentViewOuterSpacing.bottom
      height += messageContentViewInnerSpacing.top + messageContentViewInnerSpacing.bottom
      print(height)
      if height < 60 {
        return CGSize(width: screenWidth, height: 60)
      }
      return CGSize(width: screenWidth, height: height)
    }
    
    // 타인일 경우
    let messageContentViewOuterSpacing = MessageCell.Constant.Other.MessageContentView.spacing
    let messageContentViewInnerContentSpacing = MessageContentView.Constant.MessageLabel.spacing
    let messageContentViewInnerNameSpacing = MessageContentView.Constant.MessageLabel.spacing
    messageContentViewWidth -= (messageContentViewOuterSpacing.leading + messageContentViewOuterSpacing.trailing)
    messageContentViewWidth -= (messageContentViewInnerContentSpacing
      .leading + messageContentViewInnerContentSpacing.trailing)
    rect = CGRect(x: 0, y: 0, width: messageContentViewWidth, height: 60)
    let messageLabel = UILabel(frame: rect).set {
      $0.font = .systemFont(ofSize: MessageContentView.Constant.MessageLabel.fontSize)
      $0.text = item.message
      $0.numberOfLines = 0
      $0.textAlignment = .left
      $0.sizeToFit()
    }
    
    let nameLabel = UILabel().set {
      $0.font = .systemFont(ofSize: MessageContentView.Constant.NameLabel.fontSize)
      $0.text = "hi"
      $0.numberOfLines = 1
      $0.textAlignment = .left
      $0.sizeToFit()
    }
    
    height += messageLabel.bounds.height
    height += nameLabel.bounds.height
    height += messageContentViewOuterSpacing.top + messageContentViewOuterSpacing.bottom
    height += messageContentViewInnerNameSpacing.top + messageContentViewInnerNameSpacing.bottom
    height += messageContentViewInnerContentSpacing.top + messageContentViewInnerContentSpacing.bottom
    if height < 60 {
      return CGSize(width: screenWidth, height: 60)
    }
    return CGSize(width: screenWidth, height: height)
  }
}
