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
    print(AppSetting.getUser())
    messageListView = MessageListView(
      naviBarHeight: navigationBarHeight,
      statusBarHeight: statusBarHeight,
      safeAreaBottomHeight: safeAreaBottomHeight)
    view.backgroundColor = .clear
    view.clipsToBounds = true
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.isHidden = true
    setMessageListView()
    adapter = GroupViewAdapter(
      dataSource: vm,
      collectionView: messageListView.groupView,
      delegate: self)
    bindAddGroupButton()
    vm.fetchProfile {
      guard let image = $0 else { return }
      DispatchQueue.main.async {
        self.messageListView.configureNaviBar(with: image)
      }
    }
    vm.fetchAllGroupMessageRoomList {
      self.messageListView.reloadGroupList()
    }
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
    messageListView.reloadGroupList()
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
        self?.coordinator?.gotoCreatingGroupPage()
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
    sideMenu?.delegate = self
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
  func didSelectItemAt(_ indexPath: IndexPath, groupId: Int) {
    coordinator?.gotoChattingPage(with: groupId)
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
    vm.fetchProfile {
      guard let image = $0 else { return }
      DispatchQueue.main.async {
        self.messageListView.configureNaviBar(with: image)
      }
    }
  }
}

// MARK: - MessageListSideMenuLeftMenuViewDelegate
extension MessageListViewController: MessageListSideMenuLeftMenuViewDelegate {
  func didTapEditProfile() {
    coordinator?.gotoEditProfilePage { [unowned self] state in
      // 여기서 값들 받아서 하자
      // 여기서 그냥 델리게이트 보낼껀데 이거가지고 여요 이제 그 에디팅하는 VC호출하자 카카오톡처럼
      switch state {
      case .cancel:
        break
      case .name:
        tapName()
      case .nickname:
        tapNickname()
      case .profile:
        tapProfile()
      }
    }
  }
  
  func didTapBuyMeACoffeePage() {
    coordinator?.gotoBuyMeACoffeePage()
  }
  
  func didTapAboutUsPage() {
    coordinator?.gotoAboutUsPage()
  }
  
  func didTapLoginPage() {
    coordinator?.gotoLoginPage()
  }
}

// MARK: - EditingProfileAlertDelegate
extension MessageListViewController {
  func tapProfile() {
    DispatchQueue.main.async {
      self.coordinator?.gotoProfileEditPage(with: self)
    }
  }
  
  func tapNickname() {
    let vc = ProfileEditingViewController(with: .nickname)
    present(vc, animated: true)
  }
  
  func tapName() {
    let vc = ProfileEditingViewController(with: .name)
    present(vc, animated: true)
  }
}

// MARK: - UIImagePickerControllerDelegate
extension MessageListViewController: UIImagePickerControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    var newImage: UIImage?
    if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      newImage = editedImage
    } else if let originImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      newImage = originImage
    }
    guard let jpegData = newImage?.jpegData(compressionQuality: 0.83) else { return }
    vm.uploadProfile(with: jpegData) { [weak self] in
      self?.sideMenu?.setUserInfo()
    }
    picker.dismiss(animated: true)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}

// MARK: - UINavigationControllerDelegate
extension MessageListViewController: UINavigationControllerDelegate { }

extension MessageListViewController: CreatingGroupBottomSheetViewControllerDelegate {
  func bottomSheetControllerWillDismiss() {
    // 와 대박신기.
    // 이상하게 그룹 추가했을때 커스텀 바텀 시트를 했엇는데 얘가 내려갈땐 현재 뷰의 viewWillAppear 호출을 안하네..
    vm.fetchAllGroupMessageRoomList {
      self.messageListView.reloadGroupList()
      /// 그리고 메시지 뷰의 맨 오른쪽으로 이동하게
      /// selectedcell 호출시키자.
      self.messageListView.moveToLastCell()
    }
  }
}
