//
//  ChatListViewController.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/29.
//

import UIKit

class ChatListViewController: UIViewController {
  // MARK: - Properties
  ///
  /// 이부분 이 화면 올 때 같이 대입해줘야함 첫 로그인 때 내가 저장해보리자
  private lazy var leftNaviView = ChatListLeftNaviItem(with: "아리아나 그란데말입니다")
  
  private lazy var naviBottomView = BottomNaviBar()
  
  private let vm = ChatListViewModel()
  
  private var adapter: GroupViewAdapter!
  
  private let profile = UIImageView().set {
    $0.frame = CGRect(
      origin: CGPoint(x: 0, y: 0),
      size: Constant.MyProfile.size)
    $0.layer.cornerRadius = Constant.MyProfile.size.width/2.0
    $0.clipsToBounds = true
    $0.backgroundColor = .lightGray
  }
  
  private let groupView = GroupView()
  
  private let myGroupLabel = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .boldSystemFont(ofSize: Constant.MyGroupLabel.size)
    $0.textColor = Constant.MyGroupLabel.textColor
    $0.text = "My group"
  }
  
  weak var coordinator: ChatListCoordinator?
  
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
    adapter = GroupViewAdapter(dataSource: vm)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    guard let touch = touches.first else { return }
    let touchLocation = touch.location(in: self.view)
    if !naviBottomView.searchBarView.frame.contains(touchLocation) {
      naviBottomView.hideKeyboard()
    }
  }
}

// MARK: - Private helpers
private extension ChatListViewController {
  func configureUI() {
    view.backgroundColor = UIColor(hex: "#F8F8FA")
    setNavigationBar()
    setupUI()
    setNaviBottomViewShadow()
  }
  
  func setNavigationBar() {
    navigationController?.navigationBar.backgroundColor = .white
    let appearance = UINavigationBarAppearance()
  
    appearance.backgroundColor = .white
    appearance.shadowColor = .clear
    navigationController?.navigationBar.standardAppearance = appearance
    navigationController?.navigationBar.scrollEdgeAppearance = appearance
    
    let leftBarItem = UIBarButtonItem(customView: leftNaviView)
    navigationItem.leftBarButtonItem = leftBarItem
    
    let profile = UIImageView().set {
      $0.frame = CGRect(
        origin: CGPoint(x: 0, y: 0),
        size: Constant.MyProfile.size)
      $0.layer.cornerRadius = Constant.MyProfile.size.width/2.0
      $0.clipsToBounds = true
      $0.backgroundColor = .lightGray
    }
    let rightBarItem = UIBarButtonItem(customView: profile)
    navigationItem.rightBarButtonItem = rightBarItem
  }
  
  func setNaviBottomViewShadow() {
    naviBottomView.setShadow()
  }
}

// MARK: - LayoutSupport
extension ChatListViewController: LayoutSupport {
  func addSubviews() {
    _=[groupView, naviBottomView].map { view.addSubview($0) }
  }
  
  func setConstraints() {
    _=[groupViewConstraints, naviBottomViewConstraints].map { NSLayoutConstraint.activate($0) }
  }
}

private extension ChatListViewController {
  var groupViewConstraints: [NSLayoutConstraint] {
    [groupView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
     groupView.topAnchor.constraint(
      equalTo: naviBottomView.bottomAnchor,
      constant: 50),
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
}
