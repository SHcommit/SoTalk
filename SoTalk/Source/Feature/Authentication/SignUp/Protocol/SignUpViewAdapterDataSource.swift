//
//  SignUpViewAdapterDataSource.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/28.
//

import Foundation

protocol SignUpViewAdapterDataSource: AnyObject {
  var numberOfItems: Int { get }
  func cellItem(
    at index: Int
  ) -> String
}
