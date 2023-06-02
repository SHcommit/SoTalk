//
//  CreatingGroupBottomSheetViewController.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/02.
//

import UIKit
import Combine

extension CreatingGroupBottomSheetViewController {
  enum Constant {
    enum View {
      static let cornerRadius = 35.0
    }
    
    enum GrayBar {
      static let spacing: UISpacing = .init(top: 20)
      static let size = CGSize(width: 50.0, height: 2.0)
    }
    
    enum CloseButton {
      static let spacing: UISpacing = .init(trailing: 30.0)
      static let size = CGSize(width: 26.0, height: 26.0)
    }
  }
}

final class CreatingGroupBottomSheetViewController: UIViewController {
  // MARK: - Properties
  private let blurView = UIView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
  }
  
  private let cancelButton = UIButton().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.setImage(UIImage(named: "close"), for: .normal)
    $0.backgroundColor = .black
  }
  
  private let grayBar = UIView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.layer.cornerRadius = 5
    $0.backgroundColor = .darkGray
  }
  
  weak var coordinator: FlowCoordinator?
  
  var subscription = Set<AnyCancellable>()
  
  // MARK: - Lifecycle
  private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }
  
  required init(coder: NSCoder) {
    fatalError()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.layer.cornerRadius = Constant.View.cornerRadius
    view.clipsToBounds = true
    setupUI()
    bindEvent()
  }
}

// MARK: - Private helper
private extension CreatingGroupBottomSheetViewController {
  
  func bindEvent() {
    cancelButton
      .tap
      .receive(on: DispatchQueue.main)
      .sink { _ in
        self.dismiss(animated: true)
      }.store(in: &subscription)
  }
}

// MARK: - LayoutSupport
extension CreatingGroupBottomSheetViewController: LayoutSupport {
  func addSubviews() {
    _=[blurView, grayBar, cancelButton].map { view.addSubview($0) }
  }
  
  func setConstraints() {
    _=[blurViewConstrants,
       grayBarConstraints,
       cancelButtonConstarints]
      .map { NSLayoutConstraint.activate($0) }
  }
}

// MARK: - LayoutSupport helper
private extension CreatingGroupBottomSheetViewController {
  var blurViewConstrants: [NSLayoutConstraint] {
    [blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
     blurView.topAnchor.constraint(equalTo: view.topAnchor),
     blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
     blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
  }
  
  var grayBarConstraints: [NSLayoutConstraint] {
    [grayBar.topAnchor.constraint(
        equalTo: view.topAnchor,
        constant: Constant.GrayBar.spacing.top),
     grayBar.centerXAnchor.constraint(
      equalTo: view.centerXAnchor),
     grayBar.widthAnchor.constraint(
      equalToConstant: Constant.GrayBar.size.width),
     grayBar.heightAnchor.constraint(
      equalToConstant: Constant.GrayBar.size.height)]
  }
  
  var cancelButtonConstarints: [NSLayoutConstraint] {
    [cancelButton.centerYAnchor.constraint(
      equalTo: grayBar.centerYAnchor),
     cancelButton.trailingAnchor.constraint(
      equalTo: view.trailingAnchor,
      constant: -Constant.CloseButton.spacing.trailing),
     cancelButton.widthAnchor.constraint(
      equalToConstant: Constant.CloseButton.size.width),
     cancelButton.heightAnchor.constraint(
      equalToConstant: Constant.CloseButton.size.height)]
  }
}
