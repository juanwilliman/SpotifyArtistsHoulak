//
//  AuthorizationView.swift
//  SpotArtists
//
//  Created by Juan Williman on 4/22/22.
//

import SwiftUI

struct AuthorizationView: View {
    
    @State var tokenTextFieldText: String = ""
    @State var showTokenUpdatedAlert: Bool = false
    
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @EnvironmentObject var spotifyController: SpotifyController

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Functions

    func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color("BackgroundColor").ignoresSafeArea()
            Details
            BottomBar
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .alert(isPresented: $showTokenUpdatedAlert) {
            Alert(title: Text("Token Updated"), message: Text("The Authorization Token has been successfully updated."), dismissButton: .default(Text("OK").bold()))
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
    
    // MARK: - Details
    
    var Details: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 20) {
                Title(text: "Token")
                TokenCell
                GetNewTokenCell
                Spacer().frame(height: 100)
            }
            .padding(EdgeInsets(top: 7, leading: 16, bottom: 0, trailing: 16))
        }
        .frame(width: UIScreen.main.bounds.width)
        .padding(.top, 1)
    }
    
    // MARK: - Token Cell
    
    var TokenCell: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionTitle(text: "Authenticate")
            HStack {
                TokenBar.padding(.trailing, 10)
                SaveButton
            }.padding(hasHomeButton() ? 3 : 6)
        }
    }
    
    var SaveButton: some View {
        Button(action: {
            spotifyController.setNewAuthorizationToken(token: tokenTextFieldText)
            tokenTextFieldText = ""
            hideKeyboard()
            showTokenUpdatedAlert = true
        }) {
            PrimaryActionButton(glyph: "checkmark", text: "Save")
        }
        .buttonStyle(WithMotion())
        .disabled(tokenTextFieldText.isEmpty)
        .opacity(tokenTextFieldText.isEmpty ? 0.5 : 1)
    }
    
    var TokenBar: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .foregroundColor(.clear)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 25, style: .continuous))
                .shadow(color: .black.opacity(0.08), radius: 13, x: 0, y: 5)
            if (tokenTextFieldText.isEmpty) {
                Text("New Token")
                    .font(Font.custom(themeViewModel.selectedFont ? boldFont : lightFont, size: 18))
                    .foregroundColor(.primary)
                    .opacity(0.4)
                    .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 22))
            }
            TextField("", text: $tokenTextFieldText)
                .font(Font.custom(themeViewModel.selectedFont ? boldFont : lightFont, size: 18))
                .foregroundColor(.primary)
                .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 22))
        }
        .frame(height: 60)
    }
    
    // MARK: - Get New Token Cell
    
    var GetNewTokenCell: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionTitle(text: "New Token")
            Link(destination: URL(string: "https://developer.spotify.com/console/get-search-item/")!) {
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .foregroundColor(.white.opacity(colorScheme == .light ? 1 : 0.1))
                        .shadow(color: .black.opacity(0.03), radius: 30, x: 0, y: 20)
                    HStack {
                        Image(systemName: "network")
                            .font(.system(size: 33))
                            .foregroundColor(.green)
                            .padding(.trailing, 5)
                        VStack(alignment: .leading) {
                            Text("Spotify Auth")
                                .font(Font.custom(themeViewModel.selectedFont ? boldFont : lightFont, size: 18))
                                .foregroundColor(.primary)
                            Text("Get a New Token")
                                .font(Font.custom(themeViewModel.selectedFont ? boldFont : regularFont, size: 13))
                                .minimumScaleFactor(0.8)
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.primary)
                                .opacity(0.3)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.primary)
                            .opacity(0.2)
                            .font(.system(size: 18))
                    }
                    .padding(EdgeInsets(top: 20, leading: 23, bottom: 20, trailing: 27))
                }
            }
            .buttonStyle(BigWithMotion())
            .padding(hasHomeButton() ? 3 : 6)
            HStack {
                Spacer()
                Text("Request a Token with the Scopes 'user-read-private' and 'user-top-read'. Then copy the Token and paste it into the Text Field above.")
                    .font(Font.custom(themeViewModel.selectedFont ? boldFont : regularFont, size: 15))
                    .minimumScaleFactor(0.4)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3.5)
                    .opacity(0.4)
                    .padding(EdgeInsets(top: 5, leading: 30, bottom: hasHomeButton() ? 7 : 10, trailing: 30))
                Spacer()
            }
        }
    }
    
}
