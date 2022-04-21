//
//  Artist.swift
//  SpotArtists
//
//  Created by Juan Williman on 4/21/22.
//

import Foundation

struct Artist: Decodable, Hashable {
    
    var genres: [String]
    var id: String
    var images: [ArtistImage]?
    var name: String
    var popularity: Int
    
    static func == (lhs: Artist, rhs: Artist) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

struct ArtistImage: Decodable {
    var url: String
}
