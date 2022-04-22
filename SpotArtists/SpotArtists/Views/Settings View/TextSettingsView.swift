//
//  TextSettingsView.swift
//  SpotArtists
//
//  Created by Juan Williman on 4/21/22.
//

import SwiftUI

struct TextSettingsView: View {
    
    @EnvironmentObject var themeViewModel: ThemeViewModel

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Functions

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
                Title(text: "Text")
                FontCell
                ButtonLabelsCell
                Spacer().frame(height: 100)
            }
            .padding(EdgeInsets(top: 7, leading: 16, bottom: 0, trailing: 16))
        }
        .frame(width: UIScreen.main.bounds.width)
        .padding(.top, 1)
    }
    
    // MARK: - Button Labels Cell
    
    var ButtonLabelsCell: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionTitle(text: "Button Labels")
            HStack(spacing: 17) {
                Button(action: { themeViewModel.selectWithoutLabels() }) {
                    RectangleButton(text: "Hide\nLabels", glyph: "tag.slash.fill", color: .orange.opacity(0.4), isSelected: !themeViewModel.showButtonLabels)
                }.buttonStyle(WithMotion())
                Button(action: { themeViewModel.selectWithLabels() }) {
                    RectangleButton(text: "Show\nLabels", glyph: "tag.fill", color: .orange, isSelected: themeViewModel.showButtonLabels)
                }.buttonStyle(WithMotion())
            }
            .padding(hasHomeButton() ? 3 : 6)
        }
    }
    
    // MARK: - Font Cell
    
    var FontCell: some View {
        VStack(alignment: .leading, spacing: 20) {
            SectionTitle(text: "Font Weight")
            HStack(spacing: 17) {
                Button(action: { themeViewModel.selectBold() }) {
                    RectangleButton(text: "Bold", glyph: "bold", color: .gray, isSelected: themeViewModel.selectedFont)
                }.buttonStyle(WithMotion())
                Button(action: { themeViewModel.selectLight() }) {
                    RectangleButton(text: "Light", glyph: "character", color: .gray, isSelected: !themeViewModel.selectedFont)
                }.buttonStyle(WithMotion())
            }
            .padding(hasHomeButton() ? 3 : 6)
        }
    }
    
}

