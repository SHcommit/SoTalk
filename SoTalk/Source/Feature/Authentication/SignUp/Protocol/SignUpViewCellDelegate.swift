//
//  SignUpViewCellDelegate.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/28.
//

import Foundation

protocol SignUpViewCellDelegate: AnyObject {
  func goToNextPage(_ text: String, currentIndexPath: IndexPath)
}
