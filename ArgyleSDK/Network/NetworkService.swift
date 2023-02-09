//
//  NetworkService.swift
//  Argyle
//
//  Created by Gabriel Mocelin on 07/02/23.
//

import Foundation

protocol NetworkService {
    @discardableResult
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, NetworkError>) -> Void) -> UUID
    func cancel(requestUUID: UUID)
}

final class RealNetworkService: NetworkService {
    var runningRequests: [UUID: URLSessionDataTask] = [:]

    @discardableResult
    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, NetworkError>) -> Void) -> UUID {
        var urlRequest = URLRequest(url: request.url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers

        let uuid = UUID()

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            defer { self.runningRequests[uuid] = nil }

            if let error {
                return completion(.failure(.system(.init(error: error))))
            }

            guard let data else {
                return completion(.failure(NetworkError.noData))
            }

            do {
                try completion(.success(request.decode(data)))
            } catch let error {
                completion(.failure(.system(.init(error: error))))
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

final class MockNetworkService: NetworkService {
    var shouldFail: Bool = false
    var completionTime: TimeInterval = 0

    func request<Request: DataRequest>(_ request: Request, completion: @escaping (Result<Request.Response, NetworkError>) -> Void) -> UUID {
        DispatchQueue.main.asyncAfter(deadline: .now() + completionTime) { [weak self] in
            if let mock = request.mock, self?.shouldFail == false {
                completion(.success(mock))
            } else if request.mock == nil {
                completion(.failure(NetworkError.noData))
            } else {
                completion(.failure(NetworkError.unknown))
            }
        }

        return UUID()
    }

    func cancel(requestUUID: UUID) { }
}
