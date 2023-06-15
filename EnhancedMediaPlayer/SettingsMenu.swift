// SettingsMenu.swift

import SwiftUI

struct SettingsMenu: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.stackSpacing) {
            renderSettingsItem()
            renderSettingsItem()
            renderSettingsItem()
        }
        .padding(Constants.stackSpacing)
        .background(.background)
        .cornerRadius(Constants.cornerRadius)
    }

    @ViewBuilder private func renderSettingsItem() -> some View {
        HStack {
            Image(systemName: Constants.itemIcon)
            Text(Constants.itemText)
        }
    }
}

extension SettingsMenu {
    enum Constants {
        static let itemIcon: String = "gearshape.fill"
        static let itemText: String = "Settings item"
        static let cornerRadius: CGFloat = 12
        static let stackSpacing: CGFloat = 8
    }
}

struct SettingsMenu_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenu()
    }
}
