//
//  CustonTextfieldState.swift
//  SoTalk
//
//  Created by 양승현 on 2023/05/26.
//

import UIKit

enum AuthenticationTextFieldColorState {
  case notEditing
  case editing
  case inputExcess
  
  var color: UIColor {
    switch self {
    case .notEditing: return .Palette.grayLine
    case .editing: return .Palette.primary
    case .inputExcess: return .Palette.errorRed
    }
  }
}
