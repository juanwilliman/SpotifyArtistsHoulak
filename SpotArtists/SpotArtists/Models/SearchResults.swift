//
//  SearchResults.swift
//  SpotArtists
//
//  Created by Juan Williman on 4/21/22.
//

import Foundation

struct SearchResults: Decodable {
    var artists: ArtistsList
}

struct ArtistsList: Decodable {
    var items: [Artist]
    var total: Int
}
