//
//  MessageTextViewDelegate.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import Foundation

protocol MessageTextViewDelegate: AnyObject {
  func changed(text: String)
}
