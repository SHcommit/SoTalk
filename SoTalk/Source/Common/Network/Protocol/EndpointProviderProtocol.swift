//
//  EndpointProvider.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/04.
//

import Foundation

protocol EndpointProvider: AnyObject {
  func request<R: Decodable, M: HTTPMessage>(
    with endpoint: M,
    completion: @escaping (Result<R, Error>) -> Void
  ) where M.Response == R
  
  func request(
    _ url: URL,
    completion: @escaping (Result<Data, Error>) -> Void)
}
