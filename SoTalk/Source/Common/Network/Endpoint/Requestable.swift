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
  var servPort: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var queryParameters: Encodable? { get }
  var bodyParameters: Encodable? { get }
  var headers: [String: String]? { get }
  var sampleData: Data? { get }
  var multipartDTO: MultipartInputDTO? { get }
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
    } else if let multipartDTO = multipartDTO {
      let fileData = createMultipartFileData(
        with: multipartDTO)
      urlRequest.httpBody = fileData
    }
    _=headers?.map {
      urlRequest.setValue($1, forHTTPHeaderField: $0)
    }
    
    print("DEBUG: \(url)")
    return urlRequest
  }
  
  func url() throws -> URL {
    let urlStr = "\(entryProtocol)\(servIP):\(servPort)/\(path)"
    
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

private extension Requestable {
  func createMultipartFileData(
    with input: MultipartInputDTO
  ) -> Data {
    let data = NSMutableData()
    let lineBreak = "\r\n"
    
    data.appendString("--\(input.boundary)\(lineBreak)")
    if let userId = input.userId {
      data.appendString(
        "Content-Disposition: form-data; name=\"userId\"\(lineBreak)\(lineBreak)")
      data.appendString("\(userId)\(lineBreak)")
    } else if let groupId = input.groupId {
      data.appendString(
        "Content-Disposition: form-data; name=\"groupId\"\(lineBreak)\(lineBreak)")
      data.appendString("\(groupId)\(lineBreak)")
    }

    data.appendString("--\(input.boundary)\(lineBreak)")
    
    // 요거는 파일명안에 뭐 안뜬데 .jpeg이런거
    data.appendString("Content-Disposition: form-data; name=\"\(input.fieldName)\"; filename=\"\(input.fileName)\"\(lineBreak)")
    data.appendString("Content-Type: \(input.mimeType)\(lineBreak)\(lineBreak)")
    data.append(input.fileData)
    data.appendString(lineBreak)
    
    
//
//    data.appendString(
//      "Content-Disposition: form-data; name=\"\(input.fieldName)\"\(lineBreak)\(lineBreak)")
//    data.appendString(
//      "Content-Type: \(input.mimeType)\(lineBreak)\(lineBreak)")
//
//    data.appendString(
//      "Content-Disposition: form-data; name=\"\(input.fieldName)\"\(lineBreak)\(lineBreak)")
//    data.appendString("\(input.userId)\(lineBreak)")
//    data.append(input.fileData)
//    data.appendString(lineBreak)
    
    data.appendString("--\(input.boundary)--\(lineBreak)")
    return data as Data
  }
}

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      append(data)
    }
  }
}
