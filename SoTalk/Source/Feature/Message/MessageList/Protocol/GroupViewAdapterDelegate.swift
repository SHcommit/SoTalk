//
//  GroupViewAdapterDelegate.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import Foundation

protocol GroupViewAdapterDelegate: AnyObject {
  func didSelectItemAt(_ indexPath: IndexPath, groupId: Int)
}
