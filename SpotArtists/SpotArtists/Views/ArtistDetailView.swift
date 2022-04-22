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
            spotifyController.getArtistTopTracks(id: artist.id, tracksCompletionHandler: { tracks, error in
                if let tracks = tracks {
                    self.topTracks = tracks
                }
            })
        }
        .alert(isPresented: $spotifyController.showErrorAlert) {
            Alert(title: Text("Error"), message: Text(spotifyController.errorMessage), dismissButton: .default(Text("OK").bold()))
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
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 25) {
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
                if (!topTracks.isEmpty) { TopTracks }
                if (artist.genres.isEmpty && topTracks.isEmpty) {
                    HStack {
                        Spacer()
                        Text("This Artist doesn't have a specified Genre and Top Tracks.")
                            .font(Font.custom(themeViewModel.selectedFont ? boldFont : regularFont, size: 15))
                            .minimumScaleFactor(0.4)
                            .multilineTextAlignment(.center)
                            .lineSpacing(3.5)
                            .opacity(0.4)
                            .padding(EdgeInsets(top: 5, leading: 30, bottom: hasHomeButton() ? 7 : 10, trailing: 30))
                        Spacer()
                    }
                }
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
        VStack(alignment: .leading, spacing: 25) {
            SectionTitle(text: "Genres")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    Spacer().frame(width: 10)
                    ForEach(artist.genres, id: \.self) { genre in
                        GenresCell(text: genre)
                    }
                    Spacer().frame(width: 10)
                }
            }.padding([.leading, .trailing], -16)
        }.padding(.top, -25)
    }
    
    // MARK: - Top Tracks

    @ViewBuilder
    var TopTracks: some View {
        VStack(alignment: .leading, spacing: 25) {
            SectionTitle(text: "Top Tracks")
            LazyVStack(alignment: .leading, spacing: 20) {
                ForEach(topTracks, id: \.self) { track in
                    TopTrackCell(text: track.name)
                }
            } .padding([.leading, .trailing], 10)
        }
    }
    
}
