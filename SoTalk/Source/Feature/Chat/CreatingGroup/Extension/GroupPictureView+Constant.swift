//
//  GroupPictureView+Constant.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/03.
//

import Foundation

extension GroupPictureView {
  enum Constant {
    static let cornerRadius = 7.0
    
    enum groupImageView {
      static let size = CGSize(
        width: CameraIVContainerView.size.width*4.0,
        height: CameraIVContainerView.size.height*6.0)
    }
    
    enum CameraIV {
      static let size = CGSize(width: 26.0, height: 26.0)
      static let imageName = "camera"
    }
    
    enum CameraIVContainerView {
      static let size = CGSize(width: 40.0, height: 40.0)
      static let spacing: UISpacing = .init(trailing: 5.0, bottom: 7.0)
    }
  }
}
