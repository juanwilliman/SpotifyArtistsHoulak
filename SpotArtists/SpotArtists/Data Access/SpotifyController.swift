//
//  SpotifyController.swift
//  SpotArtists
//
//  Created by Juan Williman on 4/21/22.
//

import Foundation
import SwiftUI

public class SpotifyController: ObservableObject {
    
    // MARK: - Token
    
    @Published var authorizationToken: String = UserDefaults.standard.string(forKey: "authorizationToken") ?? "BQC9UHLJSUs10HdkH8vP9cIxxLZxsha-jJm7JkSTlZqFYzF0_Zk93sIx5D4FXcdfdigM963HB_gpTaO_gtmUjraPReHR_d31hkezwvpaPOJAjbFQRtTbCQquSRF8LPq7Ef4Y2k0NEBYgx2D3ed5XdOydhBtxLnSPczK-YPX52UWXDuQKEA"
    
    // MARK: - Artists
    
    @Published var keywords: String = ""
    @Published var sortedArtistsList: [Artist] = []
    
    // MARK: - Error Alert
    
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = "There was an error."
        
    // MARK: - Set New Authorization Token
    
    func setNewAuthorizationToken(token: String) {
        UserDefaults.standard.set(token, forKey: "authorizationToken")
    }
    
    // MARK: - Load Search Results
    
    func loadSearchResults() {
        guard let url = URL(string: "https://api.spotify.com/v1/search?q=artist%3A\(keywords.encodeKeywords())&type=artist") else { return }
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("Bearer \(authorizationToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                self.errorMessage = String(describing: error)
                self.showErrorAlert = true
                print(String(describing: error))
                return
            }
            if let decodedData = try? JSONDecoder().decode(SearchResults.self, from: data) {
                DispatchQueue.main.async {
                    self.sortedArtistsList = []
                    decodedData.artists.items.forEach { artist in
                        self.sortedArtistsList.append(artist)
                    }
                    self.sortedArtistsList.sort { $0.popularity > $1.popularity }
                }
            } else if let decodedData = try? JSONDecoder().decode(ReceivedError.self, from: data) {
                DispatchQueue.main.async {
                    self.clearSearch()
                    self.errorMessage = "\(decodedData.error.status) - \(decodedData.error.message)"
                    self.showErrorAlert = true
                }
            }
        }.resume()
    }
    
    // MARK: - Clear Search
    
    func clearSearch() {
        self.keywords = ""
        self.sortedArtistsList = []
    }
    
    // MARK: - Get Artist's Top Tracks
    
    func getArtistTopTracks(id: String, tracksCompletionHandler: @escaping ([ArtistTrack]?, Error?) -> Void) {
        guard let url = URL(string: "https://api.spotify.com/v1/artists/\(id)/top-tracks?market=ES") else { return }
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("Bearer \(authorizationToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data else {
                self.errorMessage = String(describing: error)
                self.showErrorAlert = true
                print(String(describing: error))
                return
            }
            if let decodedData = try? JSONDecoder().decode(TopTracksSearchResults.self, from: data) {
                tracksCompletionHandler(Array(decodedData.tracks.prefix(5)), nil)
            } else if let decodedData = try? JSONDecoder().decode(ReceivedError.self, from: data) {
                self.errorMessage = "\(decodedData.error.status) - \(decodedData.error.message)"
                self.showErrorAlert = true
            }
        })
        task.resume()
    }
   
}

// MARK: - Encode Keywords

extension String {
    func encodeKeywords() -> String {
        return self.replacingOccurrences(of: " ", with: "%20")
    }
}
