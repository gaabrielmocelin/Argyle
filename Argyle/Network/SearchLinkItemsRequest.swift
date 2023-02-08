//
//  SearchLinkItemsRequest.swift
//  Argyle
//
//  Created by Gabriel Mocelin on 07/02/23.
//

import Foundation

struct SearchLinkItemsRequest: DataRequest {
    typealias Response = [LinkItem]

    var text: String?
    var limit: Int?

    var endpoint: String { "/search/link-items" }

    var queryItems: [String: String] {
        var dict: [String: String] = [:]

        if let text { dict["q"] = text }
        if let limit { dict["limit"] = "\(limit)" }

        return dict
    }

    var headers: [String : String] {
        // FIX ME: HIDE SECRET!!!
        ["9b40eed7b1d14f16ba3abfad216167e8": "kXatSEqBrGIaHeCp"]
    }

    func decode(_ data: Data) throws -> [LinkItem] {
        try JSONDecoder().decode(LinkItemsResponse.self, from: data).results
    }
}

struct LinkItemsResponse: Decodable {
    let results: [LinkItem]
}
