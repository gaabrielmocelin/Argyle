//
//  NetworkService.swift
//  Argyle
//
//  Created by Gabriel Mocelin on 07/02/23.
//

import Foundation

enum NetworkError: Error {
    case unableToParseJson
    case noData
}

protocol NetworkService {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void)
}

struct RealNetworkService: NetworkService {
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error {
                return completion(.failure(error))
            }

            guard let data else {
                return completion(.failure(NetworkError.noData))
            }

            do {
                try completion(.success(request.decode(data)))
            } catch let error {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
