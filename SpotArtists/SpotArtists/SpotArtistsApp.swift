//
//  SpotArtistsApp.swift
//  SpotArtists
//
//  Created by Juan Williman on 4/20/22.
//

import SwiftUI

@main
struct SpotArtistsApp: App {
    
    // MARK: - Variables
    
    @StateObject var themeViewModel: ThemeViewModel = ThemeViewModel()
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            MainMenuView()
                .environmentObject(themeViewModel)
                .preferredColorScheme(themeViewModel.themeIsSystem() ? .none : themeViewModel.getTheme())
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
    }
}
