//
//  SearchResults.swift
//  SpotArtists
//
//  Created by Juan Williman on 4/21/22.
//

import Foundation

// MARK: - Artists Search Results

struct SearchResults: Decodable {
    var artists: ArtistsList
}

// MARK: - Artists List

struct ArtistsList: Decodable {
    var items: [Artist]
}

// MARK: - Top Tracks Search Results

struct TopTracksSearchResults: Decodable {
    var tracks: [ArtistTrack]
}

// MARK: - Artist Track

struct ArtistTrack: Decodable, Hashable {
    var name: String
}
