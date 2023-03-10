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
        var dict = ["accept": "application/json"]

        if let authKey = Argyle.shared.authKey {
            dict["authorization"] = "Basic \(authKey)"
        }

        return dict
    }

    func decode(_ data: Data) throws -> [LinkItem] {
        try JSONDecoder().decode(LinkItemsResponse.self, from: data).results
    }

    var mock: [LinkItem]? {
        [
            .init(name: "Amazon", kind: "employer", logoURL: nil),
            .init(name: "DoorDash", kind: "gig", logoURL: nil),
            .init(name: "GrubHub", kind: "gig", logoURL: nil),
            .init(name: "Gusto", kind: "platform", logoURL: nil),
            .init(name: "Lyft", kind: "gig", logoURL: nil),
        ]
    }
}

struct LinkItemsResponse: Decodable {
    let results: [LinkItem]
}
