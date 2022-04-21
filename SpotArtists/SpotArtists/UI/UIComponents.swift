//
//  UIComponents.swift
//  SpotArtists
//
//  Created by Juan Williman on 4/21/22.
//

import SwiftUI

// MARK: - Notched Device Detection

public func hasHomeButton() -> Bool {
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    let window = windowScene?.windows.first
    let bottom = window!.safeAreaInsets.bottom
    return bottom == 0
}

// MARK: - iPhone SE 1st Gen

public func isiPhoneSE1() -> Bool {
    return UIScreen.main.bounds.width == 320
}

// MARK: - Back Gesture

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}

// MARK: - Gesture Recognizers

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = (connectedScenes.first as? UIWindowScene)?.windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        tapGesture.name = "MyTapGesture"
        window.addGestureRecognizer(tapGesture)
    }
 }

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false // set to `false` if you don't want to detect tap during other gestures
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

// MARK: - Button Pressed Animations

struct WithMotion: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0, anchor: .center)
    }
}

struct BigWithMotion: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0, anchor: .center)
    }
}

// MARK: - Components

public struct BottomBarBackground: View {
    public var body: some View {
        Rectangle()
            .frame(width: UIScreen.main.bounds.width + 200, height: 200)
            .foregroundColor(.clear)
            .background(.thinMaterial, in: Rectangle())
            .offset(y: 120)
            .blur(radius: 25)
    }
}

public struct PrimaryActionButton: View {
    let glyph: String
    let text: String
    @AppStorage("selectedFont") var selectedFont: Bool = true
    @AppStorage("showButtonLabels") var showButtonLabels: Bool = false
    @AppStorage("selectedColor") var selectedColor: Bool = true
    @Environment(\.colorScheme) var colorScheme
    public var body: some View {
        VStack(spacing: 7) {
            ZStack {
                RoundedRectangle(cornerRadius: 23, style: .continuous)
                    .foregroundColor(selectedColor && glyph == "magnifyingglass" ? .accentColor : .primary)
                    .shadow(color: selectedColor && glyph == "magnifyingglass" ? .accentColor.opacity(colorScheme == .light ? 0.2 : 0) : .black.opacity(0.2), radius: 10, x: 0, y: 10)
                Image(systemName: glyph)
                    .foregroundColor(Color("PrimaryNegative"))
                    .font(.system(size: 20, weight: selectedFont ? .regular : .light))
            }
            .frame(width: 60, height: 60)
            if (showButtonLabels) {
                Text(text)
                    .font(Font.custom(selectedFont ? boldFont : lightFont, size: 16))
                    .foregroundColor(glyph == "" && selectedColor ? .accentColor : .primary)
                    .offset(y: 3)
            }
        }
        .offset(y: showButtonLabels ? 12 : 0)
    }
}

public struct ListSectionHeader: View {
    let text: String
    @AppStorage("selectedFont") var selectedFont: Bool = true
    public var body: some View {
        HStack {
            Text(text)
                .font(Font.custom(selectedFont ? boldFont : regularFont, size: 30))
            Spacer()
        }
        .padding(.leading, hasHomeButton() ? 30 : 35)
    }
}
