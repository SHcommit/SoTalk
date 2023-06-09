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
  private var messageListView: MessageListView!
  
  private var sideMenu: MessageListSideMenuView?
  
  private var messageListViewOriginSize = CGAffineTransform()
  
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
    messageListView = MessageListView(
      naviBarHeight: navigationBarHeight,
      statusBarHeight: statusBarHeight,
      safeAreaBottomHeight: safeAreaBottomHeight,
      userName: "아리아나 그란데 말입니다")
    view.backgroundColor = .clear
    view.clipsToBounds = true
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.isHidden = true
    setMessageListView()
    messageListViewOriginSize = messageListView.transform
    adapter = GroupViewAdapter(
      dataSource: vm,
      collectionView: messageListView.groupView,
      delegate: self)
    bindAddGroupButton()
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
    self.messageListView.bringNavigationBarToFrontView()
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
  func bindAddGroupButton() {
    messageListView
      .addGroupButtonTap
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.coordinator?.gotoCreatingGrupPage()
      }.store(in: &subscription)
  }
  
  func setMessageListView() {
    messageListView.setLayout(from: view)
    messageListView.delegate = self
    messageListView.MessageListNavigationBarDelegate = self
    view.bringSubviewToFront(messageListView)
  }
  
  func showSideMenu() {
    sideMenu = MessageListSideMenuView()
    sideMenu?.setLayout(from: view)
    
    messageListView.subviewsIsUserInteractionNotWorking()
    view.bringSubviewToFront(messageListView)
    messageListView.setSideMenuIsWorking()
    messageListView.layer.cornerRadius = 40
    messageListView
      .setNavigationAreaUpperCornerRadius(messageListView.layer.cornerRadius)
    let moveX = UIScreen.main.bounds.width * 4.0 / 5.0
    UIView.animate(
      withDuration: 0.5,
      delay: 0,
      options: .curveEaseOut) {
        self.messageListView.transform = self.messageListView
          .transform
          .scaledBy(x: 4.0/5.0, y: 4.0/5.0)
          .translatedBy(x: moveX, y: 0)
        self.sideMenu?.showLeftMenuWithAnim()
      }
  }
  
  func hideSideMenu() {
    messageListView.setSideMenuIsNotWorking()
    messageListView.subviewsIsUserInteractionWorking()
    UIView.animate(
      withDuration: 0.3,
      delay: 0.1,
      options: .curveEaseIn
    ) {
      self.sideMenu?.hideProfileArea()
      self.sideMenu?.hideLeftMenuWithAnim()
      
    }
    UIView.animate(
      withDuration: 0.5,
      delay: 0.1,
      options: .curveEaseInOut,
    animations: {
      self.messageListView.transform = .identity
    }) {_ in
      self.messageListView.layer.cornerRadius = 0
      self.messageListView.subviewsIsUserInteractionWorking()
      self.messageListView
        .setNavigationAreaUpperCornerRadius(0)
      self.sideMenu?.removeFromSuperview()
      self.sideMenu = nil
    }
  }
}

// MARK: - GroupViewAdapterDelegate
extension MessageListViewController: GroupViewAdapterDelegate {
  func didSelectItemAt(_ indexPath: IndexPath) {
    coordinator?.gotoChattingPage()
  }
}

// MARK: - MessageListNavigationBarDelegate
extension MessageListViewController: MessageListNavigationBarDelegate {
  func didTapProfile() {
    showSideMenu()
  }
}

// MARK: - MessageListViewDelegate
extension MessageListViewController: MessageListViewDelegate {
  func tapMessageListView() {
    hideSideMenu()
  }
}

extension MessageListViewController: MessageListSideMenuLeftMenuViewDelegate {
  func didTapEditProfile() {
    
  }
  
  func didTapBuyMeACoffeePage() {
    
  }
  
  func didTapAboutUsPage() {
    
  }
  
  func didTapLoginPage() {
    
  }
}
