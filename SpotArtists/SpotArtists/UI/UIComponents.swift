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

// MARK: - Bottom Bar Background

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

// MARK: - Settings Bottom Bar Background

public struct SettingsBottomBarBackground: View {
    @Environment(\.colorScheme) var colorScheme
    public var body: some View {
        if (colorScheme == .dark) {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width + 200, height: 200)
                .foregroundColor(.black)
                .offset(y: 120)
                .blur(radius: 25)
        } else {
            Rectangle()
                .frame(width: UIScreen.main.bounds.width + 200, height: 200)
                .foregroundColor(.clear)
                .background(.thinMaterial, in: Rectangle())
                .offset(y: 120)
                .blur(radius: 25)
        }
    }
}

// MARK: - Primary Action Button

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
                    .foregroundColor(glyph == "magnifyingglass" && selectedColor ? .accentColor : .primary)
                    .offset(y: 3)
            }
        }
        .offset(y: showButtonLabels ? 12 : 0)
    }
}

// MARK: - Rectangle Button

public struct RectangleButton: View {
    let text: String
    let glyph: String
    let color: Color
    let isSelected: Bool
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("selectedFont") var selectedFont: Bool = true
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundColor(isSelected ? .white : .primary.opacity(colorScheme == .light ? 0.03 : 0.1))
                .shadow(color: .black.opacity(isSelected ? 0.03 : 0), radius: 30, x: 0, y: 20)
            VStack {
                HStack {
                    Image(systemName: glyph)
                        .foregroundColor(color)
                        .font(.system(size: 25))
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Text(text)
                        .font(Font.custom(selectedFont ? boldFont : lightFont, size: 18))
                        .foregroundColor(isSelected ? .black : .primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.trailing)
                        .minimumScaleFactor(0.5)
                }
            }
            .padding(EdgeInsets(top: 16, leading: 18, bottom: 16, trailing: 22))
        }
        .frame(height: 120)
    }
}

// MARK: - Theme Button

public struct ThemeButton: View {
    let image: Image
    let isSelected: Bool
    @Environment(\.colorScheme) var colorScheme
    public var body: some View {
        image
            .resizable()
            .scaledToFit()
            .cornerRadius(23)
            .scaleEffect(isSelected ? 1 : 0.9)
            .opacity(isSelected ? 1 : 0.8)
            .shadow(color: .black.opacity(0.13), radius: 30, x: 3, y: 20)
    }
}

// MARK: - Color Theme Button

public struct ColorThemeButton: View {
    
    let text: String
    let image: String
    let isSelected: Bool
    
    @AppStorage("selectedFont") var selectedFont: Bool = true
    @Environment(\.colorScheme) var colorScheme
    
    func getImage() -> String {
        return isSelected ? "\(image) - Light" : "\(image) - \(colorScheme == .light ? "Light" : "Dark")"
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundColor(isSelected ? .white : .primary.opacity(colorScheme == .light ? 0.03 : 0.1))
                .shadow(color: .black.opacity(isSelected ? 0.03 : 0), radius: 30, x: 0, y: 20)
            VStack {
                HStack {
                    ZStack {
                        if (colorScheme == .light || isSelected) {
                            Image(getImage())
                                .resizable()
                                .frame(width: 40, height: 40, alignment: .center)
                                .mask(Circle().frame(width: 40, height: 40))
                                .blur(radius: 10)
                                .opacity(0.45)
                                .offset(y: 8)
                        }
                        Image(getImage())
                            .resizable()
                            .frame(width: 45, height: 45, alignment: .center)
                            .mask(Circle().frame(width: 45, height: 45))
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Text(text)
                        .font(Font.custom(selectedFont ? boldFont : lightFont, size: 20))
                        .foregroundColor(isSelected ? .black : .primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
            }
            .padding(EdgeInsets(top: 11, leading: 13, bottom: 16, trailing: 22))
        }
        .frame(height: 120)
    }
}

// MARK: - App Icon Button

public struct AppIconButton: View {
    let icon: String
    let text: String
    let isSelected: Bool
    @AppStorage("selectedFont") var selectedFont: Bool = true
    @Environment(\.colorScheme) var colorScheme
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundColor(isSelected ? .white : .primary.opacity(colorScheme == .light ? 0.03 : 0.1))
            VStack(alignment: .center, spacing: 20) {
                Image(icon)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 75, height: 75, alignment: .center)
                    .cornerRadius(18)
                    .shadow(color: Color.black.opacity(0.15), radius: 15, x: 5, y: 10)
                Text(text)
                    .font(Font.custom(selectedFont ? boldFont : regularFont, size: 18))
                    .foregroundColor(isSelected ? .black : .primary)
            }
            .padding(EdgeInsets(top: 33, leading: 0, bottom: 20, trailing: 0))
        }
    }
}

// MARK: - Genres Cell

public struct GenresCell: View {
    let text: String
    @AppStorage("selectedFont") var selectedFont: Bool = true
    @Environment(\.colorScheme) var colorScheme
    public var body: some View {
        Text(text)
            .font(Font.custom(selectedFont ? boldFont : regularFont, size: 16))
            .foregroundColor(.white)
            .multilineTextAlignment(.leading)
            .padding(EdgeInsets(top: 9, leading: 12, bottom: 9, trailing: 12))
            .background(Capsule().foregroundColor(.accentColor))
    }
}

// MARK: - Title

public struct Title: View {
    let text: String
    @AppStorage("selectedFont") var selectedFont: Bool = true
    public var body: some View {
        Text(text)
            .font(Font.custom(selectedFont ? boldFont : lightFont, size: 45))
            .multilineTextAlignment(.leading)
            .padding(EdgeInsets(top: hasHomeButton() ? 7 : 25, leading: hasHomeButton() ? 7 : 15, bottom: 5, trailing: hasHomeButton() ? 7 : 15))
    }
}

// MARK: - Section Title

public struct SectionTitle: View {
    let text: String
    @AppStorage("selectedFont") var selectedFont: Bool = true
    public var body: some View {
        HStack {
            Text(text)
                .font(Font.custom(selectedFont ? boldFont : regularFont, size: 26))
            Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: hasHomeButton() ? 8 : 17, bottom: 0, trailing: hasHomeButton() ? 8 : 17))
    }
}

// MARK: - List Section Header

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
