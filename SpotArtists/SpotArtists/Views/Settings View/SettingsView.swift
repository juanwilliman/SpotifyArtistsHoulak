//
//  SettingsView.swift
//  SpotArtists
//
//  Created by Juan Williman on 4/21/22.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    
    // MARK: - Variables
    
    @State var isShowingMailView = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    
    @EnvironmentObject var themeViewModel: ThemeViewModel
    @EnvironmentObject var spotifyController: SpotifyController
            
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Functions
    
    private func back() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func toggleMail() {
        self.isShowingMailView.toggle()
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color("BackgroundColor").ignoresSafeArea()
                Details
                BottomBar
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(result: $result).ignoresSafeArea()
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
                Title(text: "Settings")
                AboutCell
                LazyVStack(alignment: .leading, spacing: 15) {
                    SectionTitle(text: "Customization")
                    ThemeCell
                    TextCell
                }
                AuthorizationCell
                ExtrasCell
                Spacer().frame(height: 100)
            }
            .padding(EdgeInsets(top: 7, leading: 16, bottom: 0, trailing: 16))
        }
        .frame(width: UIScreen.main.bounds.width)
        .padding(.top, 1)
    }
    
    // MARK: - About Cell
    
    var AboutCell: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionTitle(text: "About")
            ZStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .foregroundColor(.white.opacity(colorScheme == .light ? 1 : 0.1))
                    .shadow(color: .black.opacity(0.03), radius: 30, x: 0, y: 20)
                HStack {
                    Image("AppIconImage")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80, alignment: .center)
                        .cornerRadius(18)
                        .shadow(color: Color.black.opacity(0.15), radius: 20, x: 5, y: 8)
                        .padding(.trailing, 10)
                    VStack(alignment: .leading) {
                        Text("SpotArtists")
                            .font(Font.custom(themeViewModel.selectedFont ? boldFont : lightFont, size: 20))
                        Text("By Juan Williman")
                            .font(Font.custom(themeViewModel.selectedFont ? boldFont : regularFont, size: 15))
                            .opacity(0.4)
                    }
                    Spacer()
                }
                .padding(EdgeInsets(top: 20, leading: 23, bottom: 20, trailing: 23))
            }
            .padding(hasHomeButton() ? 3 : 6)
        }
    }
    
    // MARK: - Theme Cell
    
    var ThemeCell: some View {
        NavigationLink(destination:
                        ThemeView()
                        .navigationTitle("")
                        .navigationBarHidden(true)
        ) {
            ZStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .foregroundColor(.white.opacity(colorScheme == .light ? 1 : 0.1))
                    .shadow(color: .black.opacity(0.03), radius: 30, x: 0, y: 20)
                HStack {
                    ZStack {
                        Image(systemName: "paintpalette.fill")
                            .font(.system(size: 33))
                            .symbolRenderingMode(.multicolor)
                            .padding(.trailing, 5)
                    }
                    VStack(alignment: .leading) {
                        Text("Theme")
                            .font(Font.custom(themeViewModel.selectedFont ? boldFont : lightFont, size: 18))
                            .foregroundColor(.primary)
                        Text("Colors & App Icon")
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
    }
    
    // MARK: - Text Cell
    
    var TextCell: some View {
        NavigationLink(destination:
                        TextSettingsView()
                        .navigationTitle("")
                        .navigationBarHidden(true)
        ) {
            ZStack {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .foregroundColor(.white.opacity(colorScheme == .light ? 1 : 0.1))
                    .shadow(color: .black.opacity(0.03), radius: 30, x: 0, y: 20)
                HStack {
                    Image(systemName: "textformat")
                        .font(.system(size: 33))
                        .foregroundColor(.blue)
                        .padding(.trailing, 5)
                    VStack(alignment: .leading) {
                        Text("Text")
                            .font(Font.custom(themeViewModel.selectedFont ? boldFont : lightFont, size: 18))
                            .foregroundColor(.primary)
                        Text("Font & Buttons")
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
    }
    
    // MARK: - Authorization Cell
    
    var AuthorizationCell: some View {
        LazyVStack(alignment: .leading, spacing: 15) {
            SectionTitle(text: "Authorization")
            NavigationLink(destination:
                            AuthorizationView()
                            .environmentObject(themeViewModel)
                            .environmentObject(spotifyController)
                            .navigationTitle("")
                            .navigationBarHidden(true)
            ) {
                ZStack {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .foregroundColor(.white.opacity(colorScheme == .light ? 1 : 0.1))
                        .shadow(color: .black.opacity(0.03), radius: 30, x: 0, y: 20)
                    HStack {
                        Image(systemName: "lock.shield")
                            .font(.system(size: 33))
                            .foregroundColor(.green)
                            .padding(.trailing, 5)
                        VStack(alignment: .leading) {
                            Text("Spotify Token")
                                .font(Font.custom(themeViewModel.selectedFont ? boldFont : lightFont, size: 18))
                                .foregroundColor(.primary)
                            Text("Get new Token")
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
        }
    }
    
    // MARK: - Extras Cell
    
    var ExtrasCell: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionTitle(text: "Extras")
            VStack(spacing: 17) {
                HStack(spacing: 17) {
                    Link(destination: URL(string: "https://apps.apple.com/us/app/dey-minimal-calendar/id1588981390")!) {
                        RectangleButton(text: "Get\nDey", glyph: "arrow.down.app.fill", color: .red, isSelected: colorScheme == .light)
                    }.buttonStyle(BigWithMotion())
                    Link(destination: URL(string: "https://apps.apple.com/us/app/debotha-text-base-converter/id1593483371")!) {
                        RectangleButton(text: "Get\nDebotha", glyph: "arrow.down.app.fill", color: .orange, isSelected: colorScheme == .light)
                    }.buttonStyle(BigWithMotion())
                }
                HStack(spacing: 17) {
                    Link(destination: URL(string: "https://twitter.com/juan_williman")!) {
                        RectangleButton(text: "Follow\nMe", glyph: "at", color: .blue, isSelected: colorScheme == .light)
                    }.buttonStyle(BigWithMotion())
                    Button(action: { toggleMail() }) {
                        RectangleButton(text: "Report\nBug", glyph: "exclamationmark.bubble.fill", color: .purple, isSelected: colorScheme == .light)
                    }.buttonStyle(BigWithMotion())
                }
            }
            .padding(hasHomeButton() ? 3 : 6)
        }
    }
}
