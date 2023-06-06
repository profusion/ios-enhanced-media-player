// View+readFrame.swift

import SwiftUI

extension View {
    @ViewBuilder func readFrame(_ perform: @escaping (CGRect) -> Void) -> some View {
        self
            .background(
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: OffsetPreferenceKey.self,
                        value: proxy.frame(in: .global)
                    )
                }
            )
            .onPreferenceChange(OffsetPreferenceKey.self, perform: perform)
    }
}

private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {}
}
