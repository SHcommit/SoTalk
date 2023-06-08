//
//  MessageListViewController.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/29.
//

import UIKit
import Combine

class MessageListViewController: UIViewController {
  // MARK: - Properties
  private lazy var messageListView = MessageListView(
    naviBarHeight: navigationBarHeight,
    statusBarHeight: statusBarHeight,
    safeAreaBottomHeight: safeAreaBottomHeight,
    userName: "아리아나 그란데 말입니다")
  
  weak var coordinator: MessageListCoordinator?
  
  private let vm = MessageListViewModel()
  
  private var adapter: GroupViewAdapter!
  
  private var subscription = Set<AnyCancellable>()
  
  private var isViewDidLoad = false
  
  var statusBarHeight: CGFloat {
    var statusBarHeight: CGFloat = 0
    if #available(iOS 13.0, *) {
      let scenes = UIApplication.shared.connectedScenes
      let windowScene = scenes.first as? UIWindowScene
      let window = windowScene?.windows.first
      statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
      statusBarHeight = UIApplication.shared.statusBarFrame.height
    }
    print(statusBarHeight)
    return statusBarHeight
  }
  
  var navigationBarHeight: CGFloat {
    guard let naviBar = navigationController?.navigationBar else {
      return 44.0
    }
    return naviBar.bounds.height
  }
  
  var safeAreaBottomHeight: CGFloat {
    if #available(iOS 15.0, *) {
      if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
        let window = windowScene.windows.first
        return window?.safeAreaInsets.bottom ?? 0
      }
    } else if #available(iOS 13.0, *) {
      let window = UIApplication.shared.windows.first
      return window?.safeAreaInsets.bottom ?? 0
    }
    return 0
  }
  
  // MARK: - Lifecycle
  private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    messageListView.setLayout(from: view)
    adapter = GroupViewAdapter(
      dataSource: vm,
      collectionView: messageListView.groupView,
      delegate: self)
    eventBind()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if !isViewDidLoad {
      view.layoutIfNeeded()
      messageListView.hideSubviewsForAnimation()
      messageListView.animationSubviews()
      isViewDidLoad = true
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    guard let touch = touches.first else { return }
    let touchLocation = touch.location(in: self.view)
    if !messageListView.groupSearchViewFrame.contains(touchLocation) {
      messageListView.hideKeyboard()
    }
  }
}

// MARK: - Private helpers
private extension MessageListViewController {
  func configureUI() {
    view.backgroundColor = .clear
  }
  
  func eventBind() {
    addGroupButtonBind()
  }
  
  func addGroupButtonBind() {
    messageListView
      .addGroupButtonTap
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.coordinator?.gotoCreatingGrupPage()
      }.store(in: &subscription)
  }
}

// MARK: - GroupViewAdapterDelegate
extension MessageListViewController: GroupViewAdapterDelegate {
  func didSelectItemAt(_ indexPath: IndexPath) {
    coordinator?.gotoChattingPage()
  }
}
