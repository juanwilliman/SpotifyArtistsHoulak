//
//  ArtistListCell.swift
//  SpotArtists
//
//  Created by Juan Williman on 4/21/22.
//

import SwiftUI

// MARK: - Artist List Cell

struct ArtistListCell: View {
    
    // MARK: - Variables
    
    @State var artist: Artist
    
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            Color("BackgroundColor")
            HStack(spacing: 17) {
                ArtistPhoto
                ZStack {
                    Background
                    ArtistDetails
                    .padding(EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24))
                }
            }
            .padding(hasHomeButton() ? 0 : 6)
        }
    }
    
    // MARK: - Background
    
    var Background: some View {
        RoundedRectangle(cornerRadius: 25, style: .continuous)
            .foregroundColor(.white.opacity(colorScheme == .light ? 1 : 0.15))
    }
    
    // MARK: - Artist Photo
    
    var ArtistPhoto: some View {
        AsyncImage(url: URL(string: artist.images?.first?.url ?? "")) { image in
            image.resizable()
        } placeholder: {
            ZStack {
                Color.accentColor
                Image(systemName: "person.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .frame(width: 90, height: 90)
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    // MARK: - Artist Details
    
    var ArtistDetails: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(artist.name)
                    .font(Font.custom(themeViewModel.selectedFont ? boldFont : lightFont, size: 16))
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                Text(artist.genres.first ?? "Unknown Genre")
                    .font(Font.custom(themeViewModel.selectedFont ? boldFont : lightFont, size: 13))
                    .foregroundColor(.accentColor)
                Text("Popularity - \(artist.popularity)")
                    .font(Font.custom(themeViewModel.selectedFont ? boldFont : lightFont, size: 13))
                    .foregroundColor(.accentColor.opacity(0.4))
            }
            Spacer()
        }
    }
    
}
