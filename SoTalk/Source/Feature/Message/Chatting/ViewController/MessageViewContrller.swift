//
//  MessageViewContrller.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import UIKit
import Combine

final class MessageViewContrller: UICollectionViewController {
  // MARK: - Properties
  weak var coordinator: MessageCoordinator?
  
  var adapter: MessageViewAdapter!
  
  var vm: MessageViewModel!
  
  private var socketManager: SocketManager! {
    didSet {
      bindSocketRecv()
      socketManager.run()
    }
  }
  
  var subscription = Set<AnyCancellable>()
  
  private lazy var commentView = MessageSendBar(
    frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50)).set {
      $0.delegate = self
  }
  
  override var inputAccessoryView: UIView? {
    commentView
  }
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
    
  // MARK: - Initialization
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.register(
      MessageCell.self,
      forCellWithReuseIdentifier: MessageCell.id)
    collectionView.keyboardDismissMode = .interactive
    collectionView.alwaysBounceVertical = true
    collectionView.backgroundColor = UIColor(hex: "#F8F8FA")
  }
  
  private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    super.init(collectionViewLayout: layout)
  }
  
  convenience init(with groupId: Int, groupName: String) {
    self.init(nibName: nil, bundle: nil)
    vm = MessageViewModel(groupId: groupId)
    bindEvent(with: groupId)
    adapter = MessageViewAdapter(
      collectionView: collectionView,
      dataSource: vm)
    setNavigationBar(with: groupName)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapCollectionView))
    collectionView.addGestureRecognizer(tap)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(_:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    socketManager.closeSocket()
  }
}

// MARK: - Private helper
private extension MessageViewContrller {
  func setNavigationBar(with title: String) {
    navigationItem.title = title
    guard let navi = navigationController as? NavigationControler else {
      return
    }
    navi.setLeftBackButton(navigationItem, target: self, action: #selector(didTapBackButton))
  }
  
  func bindEvent(with groupId: Int) {
    vm.fetchGroupPort { [weak self] groupPort in
      self?.socketManager = SocketManager(groupMessageRoomPort: groupPort, groupId: groupId)
    }
    vm.fetchAllMessages()
    vm.$messageData
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.collectionView.reloadData()
      }.store(in: &subscription)
  }
  
  func bindSocketRecv() {
    socketManager.recvEvent.sink {[weak self] model in
      print(model)
      let commentModel = CommentModel(
        userId: model.userId,
        message: model.message,
        sendTime: "n",
        profileImageUrl: nil)
      self?.vm.addMesasge(with: commentModel)
    }.store(in: &subscription)
  }
}

// MARK: - Action
extension MessageViewContrller {
  @objc func didTapBackButton() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc func keyboardWillShow(_ noti: Notification) {
    // 여기서 이제 카톡처럼 키보드 높이만큼 스킄롤 롤하도록하자
  }
      
  @objc func tapCollectionView() {
    if commentView.isTextViewFirstResponder || isFirstResponder {
      commentView.hideKeyboard()
    }
  }
}

// MARK: - CommentSendInputAccessoryViewDelegate
extension MessageViewContrller: CommentSendInputAccessoryViewDelegate {
  func inputView(
    wantsToUploadComment comment: String,
    completionHandler: @escaping (Result<Void, Error>) -> Void
  ) {
    print("send comment: \(comment)")
    do {
      try socketManager.sendFor(comment, sendType: .message)
    } catch let error {
      print("DEBUG: Error occured in messageViewController.\n\tDescriptions:  \(error.localizedDescription)")
    }
    completionHandler(.success(Void()))
  }
}
