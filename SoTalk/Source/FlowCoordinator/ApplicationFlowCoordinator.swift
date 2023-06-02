//
//  ApplicationFlowCoordinator.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/31.
//

import UIKit

final class ApplicationFlowCoordinator: FlowCoordinator {
  // MARK: - Properties
  var parent: FlowCoordinator!
  var child: [FlowCoordinator] = []
  var presenter: NavigationControler = NavigationControler()
  var viewController: UIViewController! = nil
  
  private let window: UIWindow
  private var isSignIn: Bool {
    // 유저 로그인 했는지 체크
    return false
  }
  
  // MARK: - Initialization
  init(window: UIWindow) {
    self.window = window
  }
  
  func start() {
    parent = nil
    guard isSignIn else {
      // gotoLoginPage()
      gotoChatListpage()
      return
    }
    gotoChatListpage()
  }
  
  func finish() {
    print("DEBUG: App closed.")
  }
}

// MARK: - Set child coordinator
extension ApplicationFlowCoordinator {
  
  /// - Param childCoordinator : ChatListCoordinator에서 loginPage로 가야할 경우 chatListCoordinator 삭제해야합니다.
  ///
  /// Notes:
  /// 1. chatCoordinator에서 login으로 가야할 때는 chatCoordinator를 삭제해야합니다.
  /// 2. app에서 시작될 때는 삭제해야할 prev coordinator가 없음으로 그냥 window에 등록합니다.
  func gotoLoginPage(withDelete prevCoordinator: ChatListCoordinator? = nil) {
    let loginCoordinator = LoginCoordinator()
    window.rootViewController = nil
    window.rootViewController = loginCoordinator.presenter
    addChild(with: loginCoordinator)
    prevCoordinator?.finish()
  }
  
  func gotoChatListpage(withDelete prevCoordinator: LoginCoordinator? = nil) {
    let chatListCoordinator = ChatListCoordinator()
    window.rootViewController = nil
    window.rootViewController = chatListCoordinator.presenter
    addChild(with: chatListCoordinator)
    prevCoordinator?.finish()
  }
}
