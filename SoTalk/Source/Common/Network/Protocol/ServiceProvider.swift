//
//  EndpointProvider.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/04.
//

import Foundation

protocol EndpointProvider: AnyObject {
  func request<R: Decodable, E: HTTPMessage>(
    with endpoint: E,
    completion: @escaping (Result<R, Error>) -> Void
  ) where E.Response == R
  
  func request(
    _ url: URL,
    completion: @escaping (Result<Data, Error>) -> Void)
}
