//
//  MessageViewContrller.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import UIKit

// 이제 스크롤이아닌 터치했을 때 resignResponder해야함TODO: - resignResponder
final class MessageViewContrller: UICollectionViewController {
  // MARK: - Properties
  weak var coordinator: MessageCoordinator?
  
  var adapter: MessageViewAdapter!
  
  var vm: MessageViewModel!
  
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
    navigationItem.title = "Comments"
    collectionView.backgroundColor = UIColor(hex: "#F8F8FA")
    vm = MessageViewModel()
    adapter = MessageViewAdapter(
      collectionView: collectionView,
    dataSource: vm)
    setNavigationBar()
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapCollectionView))
    collectionView.addGestureRecognizer(tap)
  }
  
  private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    super.init(collectionViewLayout: layout)
  }
  
  convenience init() {
    self.init(nibName: nil, bundle: nil)
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
}

// MARK: - Private helper
private extension MessageViewContrller {
  func setNavigationBar() {
    guard let navi = navigationController as? NavigationControler else {
      return
    }
    navi.setLeftBackButton(navigationItem, target: self, action: #selector(didTapBackButton))
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
    // 여기서 이제 대화 메시지 보내자!
    completionHandler(.success(Void()))
  }
}
