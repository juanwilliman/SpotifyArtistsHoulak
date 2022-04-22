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
    @State var topTracks: [ArtistTrack] = []
    
    @EnvironmentObject var spotifyController: SpotifyController
    @EnvironmentObject var themeViewModel: ThemeViewModel
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Functions
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color("BackgroundColor").ignoresSafeArea()
                Details
                BottomBar
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .onAppear {
            self.topTracks = spotifyController.getArtistTopTracks(artist.id) ?? []
        }
    }
    
    // MARK: - Bottom Bar
    
    var BottomBar: some View {
        ZStack(alignment: .bottom) {
            SettingsBottomBarBackground()
            ZStack(alignment: .center) {
                HStack {
                    BackButton
                    Spacer()
                }
                .padding(EdgeInsets(top: 0, leading: hasHomeButton() ? 20 : 30, bottom: 17, trailing: hasHomeButton() ? 20 : 30))
                .frame(width: UIScreen.main.bounds.width)
            }
        }
    }
    
    var BackButton: some View {
        Button(action: { back() }) {
            PrimaryActionButton(glyph: "arrow.left", text: "Back")
        }.buttonStyle(WithMotion())
    }
    
    // MARK: - Top Header
    
    var TopHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                Text("Artist")
                    .font(Font.custom(themeViewModel.selectedFont ? boldFont : extraLightFont, size: isiPhoneSE1() ? 25 : 30))
                    .foregroundColor(.accentColor)
                Text(artist.name)
                    .font(Font.custom(themeViewModel.selectedFont ? boldFont : extraLightFont, size: isiPhoneSE1() ? 45 : 50))
                    .minimumScaleFactor(0.7)
                    .multilineTextAlignment(.leading)
                    .padding(.top, -12)
            }
            Spacer()
        }
        .padding([.top, .leading, .trailing], 16)
    }
    
    // MARK: - Details
    
    var Details: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                TopHeader
                ZStack {
                    artistImage
                        .frame(width: UIScreen.main.bounds.width - 60, height: UIScreen.main.bounds.width - 60)
                        .blur(radius: 25)
                        .opacity(colorScheme == .light ? 0.4 : 0)
                        .padding(35)
                        .offset(y: 40)
                    artistImage
                        .frame(width: UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.width - 50)
                        .padding(25)
                }.padding(.top, -20)
                if (!artist.genres.isEmpty) { Genres }
                Spacer().frame(height: 100)
            }
            .padding([.leading, .trailing], 16)
        }
        .frame(width: UIScreen.main.bounds.width)
        .padding(.top, 1)
    }
    
    var artistImage: some View {
        AsyncImage(url: URL(string: artist.images?.first?.url ?? "")) { image in
            image.resizable()
        } placeholder: {
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .foregroundColor(.accentColor)
                Image(systemName: "person.fill")
                    .font(.system(size: 130))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 50))
    }
    
    // MARK: - Genres
    
    @ViewBuilder
    var Genres: some View {
        VStack(alignment: .leading, spacing: 15) {
            SectionTitle(text: "Genres")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    Spacer().frame(width: 20)
                    ForEach(artist.genres, id: \.self) { genre in
                        GenresCell(text: genre)
                    }
                    Spacer().frame(width: 20)
                }
            }.padding([.leading, .trailing], -16)
        }.padding(.top, -15)
    }
    
}
