//
//  File.swift
//  testUDPSocketClient
//
//  Created by 양승현 on 2023/04/14.
//

import UIKit

final class PhotoView: UIView {
  //MARK: - Properties
  let photo: UIImageView = {
    let iv = UIImageView()
    iv.image = UIImage(named: "flower")
    iv.contentMode = .scaleAspectFill
    iv.translatesAutoresizingMaskIntoConstraints = false
    iv.clipsToBounds = true
    iv.layer.cornerRadius = 7
    return iv
  }()
  
  //MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: .zero)
    configure()
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Helpers
  private func configure() {
    translatesAutoresizingMaskIntoConstraints = false
    layer.cornerRadius = 7
    layer.shadowColor = UIColor.gray.cgColor
    layer.shadowOpacity = 0.7
    layer.shadowOffset = CGSize(width: 1, height: 2)
    layer.shadowRadius = 7
    addSubview(photo)
    NSLayoutConstraint.activate([
      photo.topAnchor.constraint(equalTo: topAnchor),
      photo.leadingAnchor.constraint(equalTo: leadingAnchor),
      photo.trailingAnchor.constraint(equalTo: trailingAnchor),
      photo.bottomAnchor.constraint(equalTo: bottomAnchor)])
  }
}
