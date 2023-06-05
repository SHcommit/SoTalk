//
//  NetworkError.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/04.
//

import Foundation

enum NetworkError: Error {
  case invalidBodyParameters
  case components
  case unknownError
  case invalidHttpStatusCode(Int)
  case emptyData
  case failedDecoding
  case urlRequest(Error)
}
