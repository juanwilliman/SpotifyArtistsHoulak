//
//  Error.swift
//  SpotArtists
//
//  Created by Juan Williman on 4/22/22.
//

import Foundation

// MARK: - Response Error

struct ResponseError: Decodable {
    var status: Int
    var message: String
}

// MARK: - Receeived Error

struct ReceivedError: Decodable {
    var error: ResponseError
}
