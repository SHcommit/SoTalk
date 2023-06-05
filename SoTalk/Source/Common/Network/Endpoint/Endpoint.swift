//
//  EndPoint.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/04.
//

import Foundation

protocol HTTPMessage: Requestable, Responsable {}

final class Endpoint<R>: HTTPMessage {
  typealias Response = R
  
  var entryProtocol: String
  var servIP: String
  var servPort: String
  var path: String
  var method: HTTPMethod
  var queryParameters: Encodable?
  var bodyParameters: Encodable?
  var headers: [String: String]?
  var sampleData: Data?
  var multipartDTO: MultipartInputDTO?
  init(
    entryProtocol: String = "http://",
    servIP: String = SecretManager.shared.serverIp,
    servPort: String = SecretManager.shared.serverPort,
    path: String = "",
    method: HTTPMethod = .get,
    queryParameters: Encodable? = nil,
    bodyParameters: Encodable? = nil,
    headers: [String: String]? = nil,
    sampleData: Data? = nil,
    multipartDTO: MultipartInputDTO? = nil
  ) {
    self.entryProtocol = entryProtocol
    self.servIP = servIP
    self.servPort = servPort
    self.path = path
    self.method = method
    self.queryParameters = queryParameters
    self.bodyParameters = bodyParameters
    self.headers = headers
    self.sampleData = sampleData
    self.multipartDTO = multipartDTO
  }
}
