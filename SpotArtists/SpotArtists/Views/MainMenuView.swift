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
    
    // MARK: - Functions
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
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
        Button(action: {
            spotifyController.loadSearchResults()
            hideKeyboard()
        }) {
            PrimaryActionButton(glyph: "magnifyingglass", text: "Search")
        }
        .buttonStyle(WithMotion())
        .disabled(spotifyController.keywords.isEmpty)
        .opacity(spotifyController.keywords.isEmpty ? 0.5 : 1)
    }
    
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
                .environmentObject(spotifyController)
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
                Text("Welcome to SpotArtists!")
                    .font(Font.custom(themeViewModel.selectedFont ? boldFont : lightFont, size: 40))
                    .multilineTextAlignment(.leading)
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 15, trailing: 60))
                Text("Search your Favorite\nSpotify Artists")
                    .font(Font.custom(themeViewModel.selectedFont ? boldFont : lightFont, size: 23))
                    .multilineTextAlignment(.leading)
                    .opacity(0.4)
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 20, trailing: 30))
            } else {
                HStack {
                    ListSectionHeader(text: "Results")
                    Spacer()
                    ClearSearchButton.padding(.trailing, 16)
                }
                ForEach(spotifyController.sortedArtistsList, id: \.self) { artist in
                    NavigationLink(destination:
                        ArtistDetailView(artist: artist)
                            .navigationTitle("")
                            .navigationBarHidden(true)
                            .environmentObject(spotifyController)
                            .environmentObject(themeViewModel)
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
