//
//  FlowCoordinator+ConvenienceInitSubCoordinator.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/31.
//

import Foundation

extension FlowCoordinator {
  
  /// child coordinator convenience init + setting!!
  ///
  /// # Example #
  /// ```
  /// MainCoordinator(apiClient: apiClient).set {
  ///   $0.partentCoordinator = self
  ///   addChild($0)
  ///   ...
  ///   $0.start()
  /// }
  /// ```
  func set(apply: @escaping (Self) -> Void) {
    apply(self)
  }
}
