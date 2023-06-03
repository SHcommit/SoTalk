//
//  GroupPictureAppendingView.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/02.
//

import UIKit

final class GroupPictureView: UIImageView {
  // MARK: - Properties
  private var previewPictureManager = PreviewGroupPictureManager.shared
  
  private let cameraImageView = UIImageView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(named: Constant.CameraIV.imageName)
    $0.contentMode = .scaleToFill
    $0.image = image
  }
  
  private let cameraImageViewContainerView = UIView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = .white
    $0.layer.cornerRadius = Constant.CameraIVContainerView.size.width/2
  }
  
  // MARK: - Lifecycle
  private override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init() {
    self.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    backgroundColor = .lightGray
    contentMode = .scaleAspectFill
    layer.cornerRadius = Constant.cornerRadius
    image = previewPictureManager.getImage()
    clipsToBounds = true
    setupUI()
    setCameraImageViewLayoutIntoContainerView()
  }
  
  required init(coder: NSCoder) { fatalError() }
}

// MARK: - Helper
extension GroupPictureView {
  @MainActor
  func setImageView(with image: UIImage?) {
    self.image = image
  }
  
  func setTapRecognizer(target: Any?, action: Selector) {
    isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: target, action: action)
    addGestureRecognizer(tap)
  }
}

// MARK: - Private helper
extension GroupPictureView {
  func setCameraImageViewLayoutIntoContainerView() {
    cameraImageViewContainerView.addSubview(cameraImageView)
    NSLayoutConstraint.activate([
      cameraImageView.centerXAnchor.constraint(
        equalTo: cameraImageViewContainerView.centerXAnchor),
      cameraImageView.centerYAnchor.constraint(
        equalTo: cameraImageViewContainerView.centerYAnchor),
      cameraImageView.widthAnchor.constraint(
        equalToConstant: Constant.CameraIV.size.width),
      cameraImageView.heightAnchor.constraint(
        equalToConstant: Constant.CameraIV.size.height)])
  }
}

// MARK: - LayoutSupport
extension GroupPictureView: LayoutSupport {
  func addSubviews() {
    _=[cameraImageViewContainerView].map { addSubview($0) }
  }
  
  func setConstraints() {
    _=[imageViewConstraints].map {
      NSLayoutConstraint.activate($0)
    }
  }
}

// MARK: - LayoutSupport helper
private extension GroupPictureView {
  var imageViewConstraints: [NSLayoutConstraint] {
    [cameraImageViewContainerView.trailingAnchor.constraint(
      equalTo: trailingAnchor,
      constant: -Constant.CameraIVContainerView.spacing.trailing),
     cameraImageViewContainerView.bottomAnchor.constraint(
      equalTo: bottomAnchor,
      constant: -Constant.CameraIVContainerView.spacing.bottom),
     cameraImageViewContainerView.widthAnchor.constraint(
      equalToConstant: Constant.CameraIVContainerView.size.width),
     cameraImageViewContainerView.heightAnchor.constraint(
      equalToConstant: Constant.CameraIVContainerView.size.height)]
  }
  
}
