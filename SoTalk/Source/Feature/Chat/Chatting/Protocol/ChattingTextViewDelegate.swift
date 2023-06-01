//
//  File.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/01.
//

import Foundation

protocol ChattingTextViewDelegate: AnyObject {
  func changed(text: String)
}
