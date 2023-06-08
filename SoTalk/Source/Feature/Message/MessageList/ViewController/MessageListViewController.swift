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
  
  private var isViewDidLoad = false
  
  weak var coordinator: MessageListCoordinator?
  
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
  
  private let vm = MessageListViewModel()
  
  private var adapter: GroupViewAdapter!
  
  /// 이부분 이 화면 올 때 같이 대입해줘야함 첫 로그인 때 내가 저장해보리자
  private lazy var messageListNavigationBar = MessageListNavigationBar(with: "아리아나 그란데말입니다")
  
  private lazy var naviBottomView = BottomNaviBar()
  
  private let groupView = GroupView()
  
  private let myGroupLabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .boldSystemFont(ofSize: Constant.MyGroupLabel.size)
    $0.textColor = Constant.MyGroupLabel.textColor
    $0.text = "My group"
  }
  
  private let addGroupButton: UIButton = UIButton().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    let text = "그룹 추가"
    let attrString = NSMutableAttributedString(string: text)
    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.white,
      .font: UIFont.systemFont(ofSize: 14)]
    attrString.addAttributes(
      attributes,
      range: NSRange(
        location: 0, length: text.count))
    $0.setAttributedTitle(
      attrString,
      for: .normal)
    $0.layer.cornerRadius = 21
    $0.backgroundColor = .Palette.primary
  }
  
  private let naviBGView = UIView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = UIColor.white
  }
  
  private var subscription = Set<AnyCancellable>()
  
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
    adapter = GroupViewAdapter(
      dataSource: vm,
      collectionView: groupView,
      delegate: self)
    eventBind()
    view.bringSubviewToFront(naviBGView)
    view.bringSubviewToFront(messageListNavigationBar)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if !isViewDidLoad {
      view.layoutIfNeeded()
      naviBottomView.layoutIfNeeded()
      naviBottomView.hideMainTitle()
      naviBottomView.hideSearchBar()
      hideMyGroupLabel()
      hideGruopView()
      addGroupButton.isHidden = true
    }
    if !isViewDidLoad {
      UIView.animate(
        withDuration: 0.4,
        delay: 0.3,
        options: .curveEaseOut,
        animations: {
          self.naviBottomView.showMainTitle()
        }) { _ in
          UIView.animate(
            withDuration: 0.4,
            delay: 0.15,
            options: .curveEaseOut) {
              self.naviBottomView.showSearchBar()
            }
        }
      
      UIView.animate(
        withDuration: 0.2,
        delay: 1,
        options: .curveEaseIn,
        animations: {
          self.showMyGroupLabel()
        }) { _ in
          UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
              self.showGroupView()}) {_ in
                UIView.animate(
                  withDuration: 0.2,
                  delay: 1.0,
                  options: .curveEaseOut) {
                    self.addGroupButton.isHidden = false
                  }
              }
          
        }
      isViewDidLoad = true
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    guard let touch = touches.first else { return }
    let touchLocation = touch.location(in: self.view)
    if !naviBottomView.searchBarView.frame.contains(touchLocation) {
      naviBottomView.hideKeyboard()
    }
  }
  
  override func viewDidLayoutSubviews() {
  }
}

// MARK: - Private helpers
private extension MessageListViewController {
  func configureUI() {
    view.backgroundColor = UIColor(hex: "#F8F8FA")
    // setNavigationBar()
    setupUI()
    setNaviBottomViewShadow()
    setAddGroupButtonShadow()
  }
  
  func eventBind() {
    addGroupButtonBind()
  }
  
  func addGroupButtonBind() {
    addGroupButton
      .tap
      .receive(on: DispatchQueue.main)
      .sink {[unowned self] _ in
        UIView.touchAnimate(self.addGroupButton) {
          // 버튼 터치했으니 그룹 만드는 화면 ㄱㄱ
          print("group add touch")
          self.coordinator?.gotoCreatingGrupPage()
        }
      }.store(in: &subscription)
  }
  
  func setNavigationBar() {
//    navigationController?.navigationBar.backgroundColor = .none
//    let appearance = UINavigationBarAppearance()
//
//    appearance.backgroundColor = .none
//    appearance.shadowColor = .clear
//    navigationController?.navigationBar.standardAppearance = appearance
//    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    
//    let leftBarItem = UIBarButtonItem(customView: leftNaviView)
//    navigationItem.leftBarButtonItem = leftBarItem
    
//    let rightBarItem = UIBarButtonItem(customView: profile)
//    navigationItem.rightBarButtonItem = rightBarItem
  }
  
  func setNaviBottomViewShadow() {
    naviBottomView.setShadow()
  }

  func setAddGroupButtonShadow() {
    addGroupButton.layer.shadowOffset = CGSize(width: 0, height: 0)
    addGroupButton.layer.shadowColor = UIColor.Palette.primary.cgColor
    addGroupButton.layer.shadowRadius = 6.0
    addGroupButton.layer.shadowOpacity = 0.3
    let width = addGroupButton.bounds.width
    let height = addGroupButton.bounds.height
    let rect = CGSize(width: width, height: height)
    let origin = CGPoint(
      x: addGroupButton.bounds.origin.x,
      y: addGroupButton.bounds.origin.y)
    
    addGroupButton.layer.shadowPath = UIBezierPath(
      roundedRect: CGRect(origin: origin, size: rect),
      cornerRadius: 6.0).cgPath
  }
}

// MARK: - Animation helpers
private extension MessageListViewController {
  func hideMyGroupLabel() {
    myGroupLabel.center.y -= 15
    myGroupLabel.alpha = 0
  }
  
  func showMyGroupLabel() {
    myGroupLabel.alpha = 1
    myGroupLabel.center.y += 15
  }
  
  func hideGruopView() {
    groupView.alpha = 0
  }
  
  func showGroupView() {
    groupView.alpha = 1
  }
}

// MARK: - GroupViewAdapterDelegate
extension MessageListViewController: GroupViewAdapterDelegate {
  func didSelectItemAt(_ indexPath: IndexPath) {
    coordinator?.gotoChattingPage()
  }
}

// MARK: - LayoutSupport
extension MessageListViewController: LayoutSupport {
  func addSubviews() {
    _=[naviBGView, messageListNavigationBar, groupView, myGroupLabel, naviBottomView, addGroupButton].map { view.addSubview($0)
    }
  }
  
  func setConstraints() {
    _=[naviBGViewConstraints,
       messageListNavigationBarConstraints,
       groupViewConstraints,
       myGroupLabelConstraints,
       naviBottomViewConstraints,
       addGroupButtonConstraints].map { NSLayoutConstraint.activate($0) }
  }
}

private extension MessageListViewController {
  var naviBGViewConstraints: [NSLayoutConstraint] {
    [naviBGView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
     naviBGView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
     naviBGView.topAnchor.constraint(equalTo: view.topAnchor),
     naviBGView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)]
  }
  
  var messageListNavigationBarConstraints: [NSLayoutConstraint] {
    [messageListNavigationBar.leadingAnchor.constraint(
      equalTo: view.leadingAnchor),
     messageListNavigationBar.trailingAnchor.constraint(
      equalTo: view.trailingAnchor),
     messageListNavigationBar.topAnchor.constraint(
      equalTo: view.topAnchor,
      constant: statusBarHeight),
     messageListNavigationBar.heightAnchor.constraint(
      equalToConstant: navigationBarHeight)]
  }
  
  var groupViewConstraints: [NSLayoutConstraint] {
    [groupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
     groupView.topAnchor.constraint(
      equalTo: myGroupLabel.bottomAnchor,
      constant: Constant.GroupView.spacing.top),
     groupView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
     groupView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)]
  }
  
  var naviBottomViewConstraints: [NSLayoutConstraint] {
    [naviBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
     naviBottomView.topAnchor.constraint(
      equalTo: view.safeAreaLayoutGuide.topAnchor),
     naviBottomView.trailingAnchor.constraint(
      equalTo: view.trailingAnchor),
     naviBottomView.heightAnchor.constraint(equalToConstant: naviBottomView.minimumHeight)]
  }
  
  var myGroupLabelConstraints: [NSLayoutConstraint] {
    [myGroupLabel.leadingAnchor.constraint(
      equalTo: view.leadingAnchor,
      constant: Constant.MyGroupLabel.spacing.leading),
     myGroupLabel.topAnchor.constraint(
      equalTo: naviBottomView.bottomAnchor,
      constant: Constant.MyGroupLabel.spacing.top)]
  }
 
  var addGroupButtonConstraints: [NSLayoutConstraint] {
    [addGroupButton.trailingAnchor.constraint(
      equalTo: view.trailingAnchor,
      constant: -Constant.AddGroupButton.spacing.trailing),
     addGroupButton.centerYAnchor.constraint(equalTo: myGroupLabel.centerYAnchor),
     addGroupButton.widthAnchor.constraint(equalToConstant: Constant.AddGroupButton.size.width),
     addGroupButton.heightAnchor.constraint(equalToConstant: Constant.AddGroupButton.size.height)]
  }
}
