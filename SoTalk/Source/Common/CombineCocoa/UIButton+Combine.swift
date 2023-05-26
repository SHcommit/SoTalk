//
//  UIButton+Combine.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/25.
//

import UIKit
import Combine

@available(iOS 13.0, *)
public extension UIButton {
  var tap: AnyPublisher<Void, Never> {
    publihser(for: .touchUpInside)
      .map { _ in }
      .eraseToAnyPublisher()
  }
  
  func tap<T: Error>(withError error: T) -> AnyPublisher<Void, T> {
    return tap
      .tryMap { _ in }
      .mapError { $0 as? T ?? error }
      .eraseToAnyPublisher()
  }

}
