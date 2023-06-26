//
//  FlowCoordinator.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/31.
//

import UIKit

protocol FlowCoordinator: AnyObject {
  // MARK: - Properteis
  var parent: FlowCoordinator! { get set }
  var child: [FlowCoordinator] { get set }
  var presenter: NavigationController { get set }
  var viewController: UIViewController! { get set }
  
  // MARK: - Helpers
  func start()
  func finish()
}

// MARK: - Manage child coordinator
extension FlowCoordinator {
  
  /// ViewController가 push될 경우. push 될 VC의 child coordinator를 parent coordinator로부터 추가해야 합니다.
  ///
  /// - Param with coordinator : push 될 VC's coordinator
  func addChild<Coordinator>(with childCoordinator: Coordinator) where Coordinator: FlowCoordinator {
    childCoordinator.set { [weak self] in
      self?.child.append($0)
      $0.parent = self
      $0.start()
    }
  }
  
  /// ViewController가 pop 되는 경우. 현재 자신의 coordinator를 상위 coordinator에서 삭제해야 합니다.
  ///
  /// - Param from parent : 현재 삭제 되려는 자식 coordinator의 부모 coordinator
  ///
  /// Notes:
  /// 1. 특정 ViewController가 deinit될 때 반드시 이 메서드를 통해 상위 부모가 소유하고 있는 자식 배열로부터 자기자신을 삭제 해야 합니다.
  ///  그렇지 않으면 parent coordinator에 계속해서 이 coordinator인스턴스는 존재하기 때문입니다.
  func removeSelf(from parent: FlowCoordinator) {
    guard let idx = parent.child.firstIndex(where: {$0===self}) else {
      print("DEBUG: Delete target \(self) is not available in child coordinators")
      return
    }
    self.removeAllChild()
    parent.child.remove(at: idx)
  }
  
  func removeAllChild() {
    child.removeAll()
  }
  
  /// 자신의 parent가 mainFlow Coordinator인지?
  func isMainCoordinator(parent coordinator: FlowCoordinator?) -> Bool {
    guard coordinator == nil else {
      print("DEBUG: Parent's info is nil")
      return false
    }
//    if parent is MainFlowCoordinator {
//      return true
//    }
    return false
  }
}
