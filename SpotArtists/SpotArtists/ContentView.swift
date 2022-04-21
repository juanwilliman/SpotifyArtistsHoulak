//
//  ContentView.swift
//  SpotArtists
//
//  Created by Juan Williman on 4/20/22.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Variables
        
    @StateObject var spotifyController: SpotifyController = SpotifyController()
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            Search
        }
        .onAppear {
            spotifyController.loadSearchResults()
        }
        .alert(isPresented: $spotifyController.showErrorAlert) {
            Alert(title: Text("Error"), message: Text(spotifyController.errorMessage), dismissButton: .default(Text("OK").bold()))
        }
    }
    
    @ViewBuilder
    var Search: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                ForEach(spotifyController.searchResults?.artists.items ?? [], id: \.self) { artist in
                    let artistName = artist.name
                    NavigationLink(destination:
                        ArtistDetailView(artist: artist)
                            .environmentObject(spotifyController)
                    ) { Text(artistName) }
                }
            }
        }
    }
    
}
