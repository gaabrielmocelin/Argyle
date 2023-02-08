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
    @discardableResult
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) -> UUID
    func cancel(requestUUID: UUID)
}

final class RealNetworkService: NetworkService {
    var runningRequests: [UUID: URLSessionDataTask] = [:]

    @discardableResult
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, Error>) -> Void) -> UUID {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers

        let uuid = UUID()

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            defer { self.runningRequests[uuid] = nil }

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

        runningRequests[uuid] = task
        task.resume()

        return uuid
    }

    func cancel(requestUUID: UUID) {
        runningRequests[requestUUID]?.cancel()
    }
}
