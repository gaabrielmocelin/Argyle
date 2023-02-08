//
//  Argyle.swift
//  ArgyleSDK
//
//  Created by Gabriel Mocelin on 08/02/23.
//

import UIKit

public final class Argyle {
    public static let shared = Argyle()

    public var apiKey: String?

    private init() { }

    public func searchController() -> UIViewController {
        SearchViewController(viewModel: SearchViewModel())
    }
}
