//
//  SignupViewController.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit

final class SignUpViewController: UIViewController {
  
  // MARK: - Properties
  private lazy var signUpView = SignUpView()
  private let vm = SignUpViewModel()
  private var adapter: SignUpViewAdapter!
  private var signUpViewCellPrevIndexPath: IndexPath?
  weak var coordinator: SignUpCoordinator?
  
  // MARK: - Lifecycle
  private override init(
    nibName nibNameOrNil: String?,
    bundle nibBundleOrNil: Bundle?
  ) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigationBar()
    setupUI()
    setAdapter()
    view.backgroundColor = .Palette.bgColor
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    coordinator?.finish()
  }
}

// MARK: - Private helper
extension SignUpViewController {
  private func setNavigationBar() {
    let attr: [NSAttributedString.Key: Any] = [
      .kern: -0.41,
      .paragraphStyle: NSMutableParagraphStyle()]
    
    navigationItem.titleView = UILabel().set {
      $0.attributedText = NSAttributedString(
        string: "회원가입",
        attributes: attr)
      $0.font = .systemFont(ofSize: 24)
      $0.textAlignment = .center
      $0.textColor = .black
    }
    
    guard
      let navigationController = navigationController as? NavigationController else {
      return
    }
    navigationController.setLeftBackButton(
      navigationItem,
      target: self,
      action: #selector(goToPrevCell))
  }

  private func setAdapter() {
    adapter = SignUpViewAdapter(
      dataSource: vm,
      delegate: self)
    signUpView.dataSource = adapter
    signUpView.delegate = adapter
  }   
}

// MARK: - Action
extension SignUpViewController {
  @objc func goToPrevCell() {
    guard let indexPath = signUpViewCellPrevIndexPath else {
      navigationController?.popViewController(animated: true)
      return
    }
    guard indexPath.row != -1 && indexPath.row != 4 else {
      navigationController?.popViewController(animated: true)
      return
    }
    
    signUpViewCellPrevIndexPath = IndexPath(
      row: indexPath.row - 1,
      section: indexPath.section)
    signUpView.scrollToItem(
      at: indexPath,
      at: .centeredHorizontally,
      animated: true)
  }
}

// MARK: - SignUpViewCellDelegate
extension SignUpViewController: SignUpViewCellDelegate {
  func goToNextPage(_ text: String, currentIndexPath indexPath: IndexPath) {
    signUpViewCellPrevIndexPath = indexPath
    let nextIndexPath = IndexPath(
      row: indexPath.row + 1,
      section: indexPath.section)
    switch indexPath.row {
    case 0:
      vm.setName(text)
    case 1:
      vm.setNickname(text)
    case 2:
      vm.setId(text)
      vm.dulicateCheck { [weak self] state in
        guard !state else {
          DispatchQueue.main.async {
            guard let cell = self?.signUpView.cellForItem(at: indexPath) as? SignUpViewCell else { return }
            cell.configure(with: "중복된 아이디 입니다.", indexPath: indexPath)
          }
          return
        }
        DispatchQueue.main.async {
          self?.signUpView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        }
        return
      }
      return
    case 3:
      vm.setPassword(text)
      vm.signUp { [weak self] state in
        self?.signUpViewCellPrevIndexPath = nextIndexPath
        if state {
          DispatchQueue.main.async {
            self?.signUpView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
          }
        } else {
          print("DEBUG: 회원가입 실패")
        }
      }
      return
    case 4:
      break
    default: break
    }
    
    signUpView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
  }
}

// MARK: - LayoutSupport
extension SignUpViewController: LayoutSupport {
  func addSubviews() {
    view.addSubview(signUpView)
  }
  
  func setConstraints() {
    NSLayoutConstraint.activate([
      signUpView.leadingAnchor.constraint(
        equalTo: view.leadingAnchor),
      signUpView.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor),
      signUpView.trailingAnchor.constraint(
        equalTo: view.trailingAnchor),
      signUpView.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
}
