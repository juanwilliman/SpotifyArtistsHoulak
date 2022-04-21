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
    
    @Published var keywords: String = "The Beatles"
    @Published var searchResults: SearchResults?
    @Published var selectedArtist: Artist?
    
    // MARK: - Error Alert
    
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = "There was an error."
    
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
                    self.searchResults = decodedData
                    print(self.searchResults!)
                }
            }
        }.resume()
    }
    
    // MARK: - Get Artist
    
    func getArtist(_ id: String) -> Artist? {
        var artist: Artist? = nil
        guard let url = URL(string: "https://api.spotify.com/v1/artists/\(id)") else { return nil }
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
            if let decodedData = try? JSONDecoder().decode(Artist.self, from: data) {
                DispatchQueue.main.async {
                    artist = decodedData
                    return
                }
            }
        }.resume()
        return artist
    }
    
}

// MARK: - Encode Keywords

extension String {
    func encodeKeywords() -> String {
        return self.replacingOccurrences(of: " ", with: "%20")
    }
}
