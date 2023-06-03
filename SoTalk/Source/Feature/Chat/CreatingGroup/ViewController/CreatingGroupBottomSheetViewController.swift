//
//  CreatingGroupBottomSheetViewController.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/02.
//

import UIKit
import Combine

final class CreatingGroupBottomSheetViewController: UIViewController {
  // MARK: - Constant
  private let Picture = 0
  private let GroupTitle = 1
  
  // MARK: - Properties
  private let blurView = UIView().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.backgroundColor = UIColor.white.withAlphaComponent(1)
  }
  
  private lazy var completionButton = UIButton().set {
    $0.isUserInteractionEnabled = false
  }
  
  private lazy var pictureView = GroupPictureView().set {
    $0.setTapRecognizer(target: self, action: #selector(didTapPicture))
  }
  
  private let textField = AuthenticationTextField(
    with: "그룹 채팅방 이름을 입력해주세요.",
    textMaxLength: Constant.TextCountPlaceholder.maximumTextLength,
    textMinLength: Constant.TextCountPlaceholder.minTextLength
  ).set {
    $0.setTextFieldHeight(Constant.TextField.height)
    $0.setValidState(.inputExcess)
  }
  
  private let textCountPlaceholder = UILabel().set {
    $0.translatesAutoresizingMaskIntoConstraints = false
    $0.font = .systemFont(ofSize: Constant.TextCountPlaceholder.textSize)
    $0.textColor = .lightGray
    $0.text = "0/\(Constant.TextCountPlaceholder.maximumTextLength) 글자"
  }
  
  weak var coordinator: CreatingGroupCoordinator?
  
  private var subscription = Set<AnyCancellable>()
  
  @Published private var selectedValueFlags = Array(repeating: false, count: 2)
  
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
    setNavigationBar()
    bind()
    textField.delegate = self
    setCompletionButtonNotWorking()
  }
}

// MARK: - Private helper
private extension CreatingGroupBottomSheetViewController {
  func setNavigationBar() {
    setRightBarButton()
    setNavigationTitleView()
    setLeftBarButton()
  }
  
  func setLeftBarButton() {
    let btn = UIBarButtonItem(customView: completionButton)
    navigationItem.leftBarButtonItem = btn
  }
  
  func setCompletionButtonNotWorking() {
    let text = "완료"
    let attrStr = NSMutableAttributedString(string: text)
    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.lightGray,
      .font: UIFont.boldSystemFont(ofSize: 14)]
    attrStr.addAttributes(
      attributes,
      range: NSRange(location: 0, length: text.count))
    _=completionButton.set {
      $0.setAttributedTitle(attrStr, for: .normal)
      $0.isUserInteractionEnabled = false
    }
  }
  
  func setCompletionButtonWorking() {
    let text = "완료"
    let attrStr = NSMutableAttributedString(string: text)
    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.Palette.primary,
      .font: UIFont.boldSystemFont(ofSize: 14)]
    attrStr.addAttributes(
      attributes,
      range: NSRange(location: 0, length: text.count))
    _=completionButton.set {
      $0.setAttributedTitle(attrStr, for: .normal)
      $0.isUserInteractionEnabled = true
    }
    
  }
  
  func setRightBarButton() {
    let closeButton = UIButton().set {
      let settingResizedImage = UIImage(named: "Close")?
        .resizableImage(
          withCapInsets: .zero,
          resizingMode: .stretch)
      let size = Constant.CloseButton.size
      let resizedImage = settingResizedImage?.resized(to: size)
      $0.setImage((resizedImage)?.withRenderingMode(.alwaysOriginal), for: .normal)
      bindCloseButton($0)
    }
    let btn = UIBarButtonItem(customView: closeButton)
    navigationItem.rightBarButtonItem = btn
  }
  
  func setNavigationTitleView() {
    let grayBar = UIView(frame: Constant.GrayBar.frame).set {
      $0.layer.cornerRadius = Constant.GrayBar.radius
      $0.backgroundColor = .darkGray
    }
    
    navigationItem.titleView = grayBar
  }
  
  func bindCloseButton(_ button: UIButton) {
    button
      .tap
      .receive(on: DispatchQueue.main)
      .sink { _ in
        self.dismiss(animated: true)
      }.store(in: &subscription)
  }
  
  func bind() {
    textField
      .changed
      .receive(on: DispatchQueue.main)
      .sink { [weak self] text in
        let maxLength = Constant.TextCountPlaceholder.maximumTextLength
        guard (2...maxLength).contains(text.count) else {
          self?.textField.setValidState(.inputExcess)
          self?.selectedValueFlags[self!.GroupTitle] = false
          self?.textCountPlaceholder.text = "\(text.count)/\(maxLength) 글자"
          return
        }
        self?.textCountPlaceholder.text = "\(text.count)/\(maxLength) 글자"
        guard !(0...1).contains(text.count) else {
          self?.textField.setValidState(.inputExcess)
          self?.selectedValueFlags[self!.GroupTitle] = false
          return
        }
        self?.textField.setValidState(.editing)
        self?.selectedValueFlags[self!.GroupTitle] = true
      }.store(in: &subscription)
    
    $selectedValueFlags
      .sink { [weak self] flags in
        guard (flags.filter { $0 }.count) == 2 else {
          self?.setCompletionButtonNotWorking()
          return
        }
        self?.setCompletionButtonWorking()
      }.store(in: &subscription)
    
    completionButton
      .tap
      .receive(on: DispatchQueue.main)
      .sink { _ in
        print("완료 했고 서버로 보낸 뒤 쳇 리스트에 추가")
      }.store(in: &subscription)
  }
}

extension CreatingGroupBottomSheetViewController: AuthenticationTextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {}
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    let maxLength = Constant.TextCountPlaceholder.maximumTextLength
    textCountPlaceholder.text = "\((textField.text ?? "").count)/\(maxLength) 글자"
  }
  
  func textFieldShouldReturn(_ textField: UITextField) {
    let maxLength = Constant.TextCountPlaceholder.maximumTextLength
    textCountPlaceholder.text = "\((textField.text ?? "").count)/\(maxLength) 글자"
  }
}

// MARK: - Action
extension CreatingGroupBottomSheetViewController {
  @objc func didTapPicture() {
    coordinator?.gotoImagePicker(self)
  }
}

// MARK: - UIImagePickerControllerDelegate
extension CreatingGroupBottomSheetViewController: UIImagePickerControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    var newImage: UIImage?
    if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      newImage = editedImage
      selectedValueFlags[Picture] = true
    } else if let originImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      newImage = originImage
      selectedValueFlags[Picture] = true
    }
    pictureView.setImageView(with: newImage)
    picker.dismiss(animated: true)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }

}

// MARK: - UINavigationControllerDelegate
extension CreatingGroupBottomSheetViewController: UINavigationControllerDelegate { }

// MARK: - LayoutSupport
extension CreatingGroupBottomSheetViewController: LayoutSupport {
  func addSubviews() {
    _=[blurView, pictureView, textField, textCountPlaceholder].map { view.addSubview($0) }
  }
  
  func setConstraints() {
    _=[blurViewConstrants, pictureViewConstraints, textFieldConstraints, textCountPlaceholderConstraints]
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
  
  var pictureViewConstraints: [NSLayoutConstraint] {
    [pictureView.topAnchor.constraint(
      equalTo: view.safeAreaLayoutGuide.topAnchor,
      constant: Constant.PictureView.spacing.top),
     pictureView.centerXAnchor.constraint(
      equalTo: view.centerXAnchor),
     pictureView.heightAnchor.constraint(
      equalToConstant: Constant.PictureView.size.height),
     pictureView.widthAnchor.constraint(
      equalToConstant: Constant.PictureView.size.width)]
  }
  
  var textFieldConstraints: [NSLayoutConstraint] {
    [textField.leadingAnchor.constraint(
      equalTo: view.leadingAnchor,
      constant: Constant.TextField.spacing.leading),
     textField.topAnchor.constraint(
      equalTo: pictureView.bottomAnchor,
      constant: Constant.TextField.spacing.top),
     textField.trailingAnchor.constraint(
      equalTo: view.trailingAnchor,
      constant: -Constant.TextField.spacing.trailing)]
  }
  
  var textCountPlaceholderConstraints: [NSLayoutConstraint] {
    [textCountPlaceholder.trailingAnchor.constraint(
      equalTo: textField.trailingAnchor,
      constant: -Constant.TextCountPlaceholder.spacing.trailing),
     textCountPlaceholder.centerYAnchor.constraint(
      equalTo: textField.centerYAnchor)]
  }
}
