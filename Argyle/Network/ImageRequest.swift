//
//  ImageRequest.swift
//  Argyle
//
//  Created by Gabriel Mocelin on 08/02/23.
//

import UIKit

struct ImageRequest: DataRequest {
    typealias Response = UIImage

    let baseURL: String
    let endpoint = ""

    func decode(_ data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else {
            throw NetworkError.unableToParseJson
        }

        return image
    }
}
