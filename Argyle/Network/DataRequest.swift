//
//  Endpoint.swift
//  Argyle
//
//  Created by Gabriel Mocelin on 07/02/23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol DataRequest {
    associatedtype Response

    var baseURL: String { get }
    var endpoint: String { get }
    var url: URL { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [String: String] { get }

    func decode(_ data: Data) throws -> Response
}

extension DataRequest {
    var baseURL: String {
        "https://api-sandbox.argyle.com/v1"
    }

    var headers: [String: String] {
        [:]
    }

    var queryItems: [String: String] {
        [:]
    }

    var method: HTTPMethod {
        .get
    }

    var url: URL {
        let urlString = baseURL + endpoint
        guard var urlComponent = URLComponents(string: urlString) else {
            preconditionFailure("The url used in \(urlString) is not valid")
        }

        urlComponent.queryItems = queryItems.map { URLQueryItem(name: $0, value: $1) }

        guard let url = urlComponent.url else {
            preconditionFailure("The url used in \(urlString) is not valid")
        }

        return url
    }
}

extension DataRequest where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        try JSONDecoder().decode(Response.self, from: data)
    }
}
