//
//  ThemeViewModel.swift
//  SpotArtists
//
//  Created by Juan Williman on 4/21/22.
//

import SwiftUI

class ThemeViewModel: ObservableObject {
    
    // MARK: - App Icon
    
    @AppStorage("selectedAppIcon") var selectedAppIcon: Bool = true
    
    func selectLightAppIcon() {
        UIApplication.shared.setAlternateIconName(nil)
        self.selectedAppIcon = true
    }
    
    func selectDarkAppIcon() {
        UIApplication.shared.setAlternateIconName("AppIcon-2")
        self.selectedAppIcon = false
    }
    
    // MARK: - Theme
    
    @AppStorage("selectedTheme") var selectedTheme: String = "System"
    
    func getTheme() -> ColorScheme {
        if (selectedTheme == "Light") { return .light }
        else { return .dark }
    }
    
    func selectSystemTheme() {
        withAnimation { self.selectedTheme = "System" }
    }
    
    func selectLightTheme() {
        withAnimation { self.selectedTheme = "Light" }
    }
    
    func selectDarkTheme() {
        withAnimation { self.selectedTheme = "Dark" }
    }
    
    func isThemeSelected(theme: String) -> Bool {
        return self.selectedTheme == theme
    }
    
    func themeIsSystem() -> Bool {
        return selectedTheme == "System"
    }
    
    // MARK: - Colors
    
    @AppStorage("selectedColor") var selectedColor: Bool = true
    
    func selectGreen() {
        withAnimation { self.selectedColor = true }
    }
    
    func selectBlackAndWhite() {
        withAnimation { self.selectedColor = false }
    }
    
    func isColorSelected(color: Bool) -> Bool {
        return self.selectedColor == color
    }
    
    // MARK: - Button Labels
    
    @AppStorage("showButtonLabels") var showButtonLabels: Bool = false
    
    func selectWithLabels() {
        withAnimation { self.showButtonLabels = true }
    }
    
    func selectWithoutLabels() {
        withAnimation { self.showButtonLabels = false }
    }
    
    func getThemeImage(theme: String) -> Image {
        return Image("\(theme) - \(selectedColor)")
    }
    
    // MARK: - Font
    
    @AppStorage("selectedFont") var selectedFont: Bool = true
    
    func selectBold() {
        withAnimation { self.selectedFont = true }
    }
    
    func selectLight() {
        withAnimation { self.selectedFont = false }
    }
    
    func selectedFontToText() -> String {
        return selectedFont ? "Bold" : "Light"
    }
    
}
