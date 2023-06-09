//
//  ServiceProviderImpl.swift
//  SoTalk
//
//  Created by 양승현 on 2023/06/04.
//

import Foundation

class ServiceProviderImpl {
  let session: URLSession
  init(session: URLSession = URLSession.shared) {
    self.session = session
  }
}

extension ServiceProviderImpl: EndpointProvider {
  func request<R, E>(
    with endpoint: E,
    completion: @escaping (Result<R, Error>) -> Void
  ) where R: Decodable, R == E.Response, E: HTTPMessage {
    do {
      let urlRequest = try endpoint.makeRequest()
      session.dataTask(with: urlRequest) { [weak self] data, response, error in
        self?.checkError(with: data, response, error) { result in
          guard let self = self else { return }
          print("DEBUG: response bytes: \(data)")
          switch result {
          case .success(let data):
            do {
              let decodedModel: R = try self.decode(data: data)
              completion(.success(decodedModel))
            } catch {
              completion(.failure(NetworkError.failedDecoding))
            }
          case .failure(let error):
            completion(.failure(error))
          }
        }
        
      }.resume()
      
    } catch {
      completion(.failure(NetworkError.urlRequest(error)))
    }
  }
  
  func request(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
    session.dataTask(with: url) { [weak self] data, response, error in
      self?.checkError(with: data, response, error) { result in
        completion(result)
      }
    }.resume()
  }
}

// MARK: - Private helper
private extension EndpointProvider {
  func checkError(
    with data: Data?,
    _ response: URLResponse?,
    _ error: Error?,
    completion: @escaping (Result<Data, Error>) -> Void
  ) {
    if let error = error {
      completion(.failure(error))
      return
    }
    
    guard let response = response as? HTTPURLResponse else {
      completion(.failure(NetworkError.unknownError))
      return
    }
    print("DEBUG: status code: \(response.statusCode)")
    guard (200...299).contains(response.statusCode) else {
      completion(.failure(NetworkError.invalidHttpStatusCode(response.statusCode)))
      return
    }
    
    guard let data = data else {
      completion(.failure(NetworkError.emptyData))
      return
    }
    
    completion(.success(data))
  }
  
  func decode<T: Decodable>(data: Data) throws -> T {
    do {
      let decoder = JSONDecoder()
      let model = try decoder.decode(T.self, from: data)
      return model
    } catch {
      throw NetworkError.emptyData
    }
  }
}
