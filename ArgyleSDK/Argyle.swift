//
//  Argyle.swift
//  ArgyleSDK
//
//  Created by Gabriel Mocelin on 08/02/23.
//

import UIKit

public final class Argyle {
    public static let shared = Argyle()

    public var apiKeyId: String?
    public var apiKeySecret: String?

    var authKey: String? {
        guard let apiKeyId, let apiKeySecret else { return nil }

        return "\(apiKeyId):\(apiKeySecret)".data(using: .utf8)?.base64EncodedString()
    }

    private init() { }

    public func searchController() -> UIViewController {
        SearchViewController(viewModel: SearchViewModel())
    }
}
