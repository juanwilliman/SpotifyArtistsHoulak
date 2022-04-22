//
//  MainMenuView.swift
//  SpotArtists
//
//  Created by Juan Williman on 4/20/22.
//

import SwiftUI

struct MainMenuView: View {
    
    // MARK: - Variables
        
    @StateObject var spotifyController: SpotifyController = SpotifyController()
    @EnvironmentObject var themeViewModel: ThemeViewModel
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color("BackgroundColor").ignoresSafeArea()
                MainView
                BottomBar
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .ignoresSafeArea(.keyboard)
        .alert(isPresented: $spotifyController.showErrorAlert) {
            Alert(title: Text("Error"), message: Text(spotifyController.errorMessage), dismissButton: .default(Text("OK").bold()))
        }
    }
    
    // MARK: - Bottom Bar
    
    var BottomBar: some View {
        ZStack(alignment: .bottom) {
            BottomBarBackground()
            ZStack(alignment: .center) {
                HStack {
                    SearchButton.padding(.trailing, 10)
                    SearchBar
                }
                .padding(EdgeInsets(top: 0, leading: hasHomeButton() ? 20 : 30, bottom: 17, trailing: hasHomeButton() ? 20 : 30))
                .frame(width: UIScreen.main.bounds.width)
            }
        }
    }
    
    var SearchButton: some View {
        Button(action: { spotifyController.loadSearchResults() }) {
            PrimaryActionButton(glyph: "magnifyingglass", text: "Search")
        }
        .buttonStyle(WithMotion())
        .disabled(spotifyController.keywords.isEmpty)
        .opacity(spotifyController.keywords.isEmpty ? 0.5 : 1)
    }
    
    // MARK: - Search Bar
    
    var SearchBar: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .foregroundColor(.clear)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 25, style: .continuous))
                .shadow(color: .black.opacity(0.08), radius: 13, x: 0, y: 5)
            if (spotifyController.keywords.isEmpty) {
                Text("Search")
                    .font(Font.custom(themeViewModel.selectedFont ? boldFont : lightFont, size: 18))
                    .foregroundColor(.primary)
                    .opacity(0.4)
                    .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 22))
            }
            TextField("", text: $spotifyController.keywords)
                .font(Font.custom(themeViewModel.selectedFont ? boldFont : lightFont, size: 18))
                .foregroundColor(.primary)
                .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 22))
        }
        .frame(height: 60)
    }
    
    // MARK: - Top Header
    
    var TopHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                Text("Spotify")
                    .font(Font.custom(themeViewModel.selectedFont ? boldFont : extraLightFont, size: isiPhoneSE1() ? 25 : 30))
                    .foregroundColor(.accentColor)
                    .minimumScaleFactor(0.5)
                Text("Artists")
                    .font(Font.custom(themeViewModel.selectedFont ? boldFont : extraLightFont, size: isiPhoneSE1() ? 45 : 50))
                    .minimumScaleFactor(0.5)
                    .padding(.top, -12)
            }
            Spacer()
            VStack {
                SettingsButton
                Spacer()
            }
        }
        .padding(EdgeInsets(top: 30, leading: 30, bottom: 20, trailing: 30))
    }
    
    var SettingsButton: some View {
        NavigationLink(destination:
            SettingsView()
                .environmentObject(themeViewModel)
                .navigationTitle("")
                .navigationBarHidden(true)
        ) {
            Image(systemName: "gear")
                .foregroundColor(.accentColor)
                .font(.system(size: 23))
        }.buttonStyle(WithMotion())
    }
    
    // MARK: - Main View
    
    var MainView: some View {
        ScrollView(.vertical) {
            VStack(spacing: 15) {
                TopHeader
                Search
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .padding(.top, 1)
    }
    
    @ViewBuilder var Search: some View {
        LazyVStack(alignment: .leading) {
            if (spotifyController.sortedArtistsList.isEmpty) {
                HStack(alignment: .center) {
                    Spacer()
                    Text("Welcome to SpotArtist by Houlak!\nSearch your favorite Spotify Artists")
                        .font(Font.custom(themeViewModel.selectedFont ? boldFont : lightFont, size: 18))
                        .multilineTextAlignment(.center)
                        .opacity(0.4)
                    Spacer()
                }.padding([.top, .bottom], 15)
            } else {
                HStack {
                    ListSectionHeader(text: "Results")
                    Spacer()
                    ClearSearchButton.padding(.trailing, 16)
                }
                ForEach(spotifyController.sortedArtistsList, id: \.self) { artist in
                    NavigationLink(destination:
                        ArtistDetailView(artist: artist)
                            .environmentObject(spotifyController)
                    ) {
                        ArtistListCell(artist: artist)
                            .environmentObject(themeViewModel)
                    }
                    .buttonStyle(BigWithMotion())
                    .padding([.leading, .trailing], 16)
                }
                Spacer().frame(height: 100)
            }
        }
    }
    
    // MARK: - Clear Search Button
    
    var ClearSearchButton: some View {
        Button(action: { spotifyController.clearSearch() }) {
            ZStack {
                Capsule()
                    .frame(width: 65, height: 36)
                    .foregroundColor(.primary)
                Text("Clear")
                    .font(Font.custom(themeViewModel.selectedFont ? boldFont : regularFont, size: 16))
                    .foregroundColor(Color("PrimaryNegative"))
            }
        }
        .buttonStyle(WithMotion())
        .padding(.trailing, 16)
    }
    
}
