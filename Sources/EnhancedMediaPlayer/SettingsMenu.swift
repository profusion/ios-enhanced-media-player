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
            renderSettingsItem()
            renderSettingsItem()
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
}

extension SettingsMenu {
    enum Constants {
        static let itemIcon: String = "gearshape.fill"
        static let itemText: String = "Settings item"
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
