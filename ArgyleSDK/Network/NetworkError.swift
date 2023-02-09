//
//  NetworkError.swift
//  ArgyleSDK
//
//  Created by Gabriel Mocelin on 08/02/23.
//

import Foundation

enum NetworkError: Error, Equatable {
    case unableToParseJson
    case noData
    case unknown
    case system(ErrorWrapper)
}

public struct ErrorWrapper: Equatable {
    let error: Error

    public static func == (lhs: Self, rhs: Self) -> Bool {
        String(reflecting: lhs.error) == String(reflecting: rhs.error)
    }
}
