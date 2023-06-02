//
//  PreviewGroupPictureManager.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/03.
//

import UIKit

struct PreviewGroupPictureManager {
  private let startNum = 1
  private let endNum = 4
  static let shared = PreviewGroupPictureManager()
  private lazy var previewImageStrings = (startNum...endNum).map { "groupPicture\($0)"}
  private init() {}
}

extension PreviewGroupPictureManager {
  // MARK: - Helper
  mutating func getImage() -> UIImage? {
    let image = UIImage(named: previewImageStrings[getRandNum()])
    return image?.compressJPEGImage(with: 0.0)
  }
  
  // MARK: - Private helper
  private func getRandNum() -> Int {
    return Int.random(in: (startNum-1...endNum-1))
  }
}
