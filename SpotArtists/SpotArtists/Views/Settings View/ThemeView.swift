//
//  ThemeView.swift
//  SpotArtists
//
//  Created by Juan Williman on 4/21/22.
//

import SwiftUI
import EventKit

struct ThemeView: View {
    
    @EnvironmentObject var themeViewModel: ThemeViewModel

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Back

    func back() {
        self.presentationMode.wrappedValue.dismiss()
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
                Title(text: "Theme")
                AppearanceCell
                ThemeCell
                AppIconCell
                Spacer().frame(height: 100)
            }
            .padding(EdgeInsets(top: 7, leading: 16, bottom: 0, trailing: 16))
        }
        .frame(width: UIScreen.main.bounds.width)
        .padding(.top, 1)
    }
    
    // MARK: - Appearance Cell
    
    
    var AppearanceCell: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                SectionTitle(text: "Appearance")
                Spacer()
                Button(action: { themeViewModel.selectSystemTheme() }) {
                    ZStack {
                        Capsule()
                            .frame(width: 65, height: 38)
                            .foregroundColor(.primary)
                            .opacity(themeViewModel.selectedTheme == "System" ? 1 : 0.1)
                        Text("Auto")
                            .font(Font.custom(themeViewModel.selectedFont ? "Pangram-Bold" : "Pangram-Regular", size: 17))
                            .foregroundColor(themeViewModel.selectedTheme == "System" ? Color("PrimaryNegative") : .primary)
                    }
                }
                .buttonStyle(WithMotion())
                .opacity(themeViewModel.selectedTheme == "System" ? 1 : 0.5)
                .padding(.trailing, 16)
            }
            .padding(.top, -5)
            HStack(spacing: 24) {
                Button(action: { themeViewModel.selectLightTheme() }) {
                    ThemeButton(image: themeViewModel.getThemeImage(theme: "Light"), isSelected: themeViewModel.isThemeSelected(theme: "Light"))
                }.buttonStyle(BigWithMotion())
                Button(action: { themeViewModel.selectDarkTheme() }) {
                    ThemeButton(image: themeViewModel.getThemeImage(theme: "Dark"), isSelected: themeViewModel.isThemeSelected(theme: "Dark"))
                }.buttonStyle(BigWithMotion())
            }
            .padding(EdgeInsets(top: 5, leading: hasHomeButton() ? 10 : 13, bottom: hasHomeButton() ? 7 : 10, trailing: hasHomeButton() ? 10 : 13))
        }
    }
    
    // MARK: - Theme Cell
    
    var ThemeCell: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionTitle(text: "Theme").padding(.top, -5)
            VStack(spacing: 17) {
                HStack(spacing: 17) {
                    Button(action: { themeViewModel.selectGreen() }) {
                        ColorThemeButton(text: "Green", image: "Green", isSelected: themeViewModel.isColorSelected(color: true))
                    }.buttonStyle(WithMotion())
                    Button(action: { themeViewModel.selectBlackAndWhite() }) {
                        ColorThemeButton(text: "B&W", image: "BlackAndWhite", isSelected: themeViewModel.isColorSelected(color: false))
                    }.buttonStyle(WithMotion())
                }
            }
            .padding(hasHomeButton() ? 3 : 6)
        }
    }
    
    // MARK: - App Icon Cell
    
    var AppIconCell: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionTitle(text: "App Icon")
            HStack(spacing: 17) {
                Button(action: { themeViewModel.selectLightAppIcon() }) {
                    AppIconButton(icon: "AppIconImage", text: "Light", isSelected: themeViewModel.selectedAppIcon)
                }.buttonStyle(WithMotion())
                Button(action: { themeViewModel.selectDarkAppIcon() }) {
                    AppIconButton(icon: "DarkAppIconImage", text: "Dark", isSelected: !themeViewModel.selectedAppIcon)
                }.buttonStyle(WithMotion())
            }
            .padding(hasHomeButton() ? 3 : 6)
        }
    }
    
}
