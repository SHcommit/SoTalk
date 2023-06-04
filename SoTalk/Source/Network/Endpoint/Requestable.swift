//
//  Requestable.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/04.
//

import Foundation

protocol Requestable {
  var entryProtocol: String { get }
  var servIP: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var queryParameters: Encodable? { get }
  var bodyParameters: Encodable? { get }
  var headers: [String: String]? { get }
  var sampleData: Data? { get }
}

extension Requestable {
  func makeRequest() throws -> URLRequest {
    let url = try url()
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method.rawValue
    if let bodyParameters = bodyParameters {
      do {
        urlRequest.httpBody = try JSONEncoder().encode(bodyParameters)
      } catch {
        throw NetworkError.invalidBodyParameters
      }
    }
    _=headers?.map {
      urlRequest.setValue($1, forHTTPHeaderField: $0)
    }
    return urlRequest
  }
  
  func url() throws -> URL {
    let urlStr = entryProtocol + servIP + path
    
    guard var components = URLComponents(string: urlStr) else { throw NetworkError.components
    }
    if let queryParameters = queryParameters?.toDictionary() {
      components.queryItems = queryParameters.map {
        URLQueryItem(name: $0.key, value: "\($0.value)")
      }
    }
    guard let url = components.url else {
      throw NetworkError.components
    }
    return url
  }
}
