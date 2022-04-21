//
//  ArtistDetailView.swift
//  SpotArtists
//
//  Created by Juan Williman on 4/21/22.
//

import SwiftUI

// MARK: - Artist Detail View

struct ArtistDetailView: View {
    
    // MARK: - Variables
    
    @State var artist: Artist
    
    @EnvironmentObject var spotifyController: SpotifyController
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 20) {
            AsyncImage(url: URL(string: artist.images?.first?.url ?? "")) { image in
                image.resizable()
            } placeholder: {
                Color.red
            }
            .frame(width: 128, height: 128)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            Text(artist.name)
            Text("\(artist.popularity)")
        }
    }
    
}
