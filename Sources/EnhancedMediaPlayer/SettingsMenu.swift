// SettingsMenu.swift

import SwiftUI

public struct SettingsMenu: View {
    @ObservedObject private var preferences: SettingsPreferences

    public init(preferences: SettingsPreferences) {
        self.preferences = preferences
    }

    public var body: some View {
        VStack(spacing: Constants.stackSpacing) {
            renderSettingsItem()
            renderPlaybackSpeedMenu()
        }
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .padding(Constants.stackPadding)
    }

    @ViewBuilder private func renderSettingsItem() -> some View {
        HStack {
            Image(systemName: Constants.itemIcon)
            Text(Constants.itemText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder private func renderPlaybackSpeedMenu() -> some View {
        Menu(Constants.rateItemText, systemImage: Constants.rateItemIcon) {
            ForEach(SettingsPreferences.PlaybackSpeedValues.allCases, id: \.self) { speed in
                renderSpeedMenuOption(speed: speed)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(.primary)
    }

    @ViewBuilder func renderSpeedMenuOption(speed: SettingsPreferences.PlaybackSpeedValues) -> some View {
        Button(action: {
            preferences.rate = speed
        }) {
            HStack {
                if preferences.rate == speed {
                    Image(systemName: Constants.selectedItemIcon)
                }
                Text(String(format: "%.2fx", speed.rawValue))
            }
        }
    }
}

extension SettingsMenu {
    enum Constants {
        static let itemIcon: String = "gearshape.fill"
        static let itemText: String = "Settings item"
        static let rateItemIcon = "gauge.with.dots.needle.67percent"
        static let rateItemText: String = "Playback speed"
        static let selectedItemIcon = "checkmark"
        static let cornerRadius: CGFloat = 12
        static let stackSpacing: CGFloat = 8
        static let stackPadding: CGFloat = 16
    }
}

struct SettingsMenu_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenu(preferences: .init())
    }
}
