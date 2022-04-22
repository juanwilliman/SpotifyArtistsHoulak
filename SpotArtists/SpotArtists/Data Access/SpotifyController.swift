//
//  SpotifyController.swift
//  SpotArtists
//
//  Created by Juan Williman on 4/21/22.
//

import Foundation
import SwiftUI

public class SpotifyController: ObservableObject {
    
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
    
    func getArtistTopTracks(_ id: String) -> [ArtistTrack]? {
        var artistTopTracks: [ArtistTrack]? = nil
        guard let url = URL(string: "https://api.spotify.com/v1/artists/\(id)/top-tracks?market=ES") else { return nil }
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
            print(String(data: data, encoding: .utf8)!)
            if let decodedData = try? JSONDecoder().decode([ArtistTrack].self, from: data) {
                DispatchQueue.main.async {
                    print(decodedData)
                    artistTopTracks = decodedData
                    return
                }
            } else if let decodedData = try? JSONDecoder().decode(ReceivedError.self, from: data) {
                DispatchQueue.main.async {
                    self.errorMessage = "\(decodedData.error.status) - \(decodedData.error.message)"
                    self.showErrorAlert = true
                }
            }
        }.resume()
        return artistTopTracks
    }
    
}

// MARK: - Encode Keywords

extension String {
    func encodeKeywords() -> String {
        return self.replacingOccurrences(of: " ", with: "%20")
    }
}
