// View+wrapInButton.swift

import SwiftUI

extension View {
    @ViewBuilder func wrapInButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            self
        }
    }
}
