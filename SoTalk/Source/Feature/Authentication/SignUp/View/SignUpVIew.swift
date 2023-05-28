//
//  SignupCollectionVIew.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/28.
//

import UIKit

final class SignUpView: UICollectionView {
  // MARK: - Properties

  // MARK: - Initialization
  private override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
  }
  
  convenience init() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    self.init(frame: .zero, collectionViewLayout: layout)
    translatesAutoresizingMaskIntoConstraints = false
    showsHorizontalScrollIndicator = false
    backgroundColor = .none
    isScrollEnabled = false
    
    self.register(
      SignUpViewCell.self,
      forCellWithReuseIdentifier: SignUpViewCell.id)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
