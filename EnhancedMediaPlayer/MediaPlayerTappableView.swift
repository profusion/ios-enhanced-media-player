// MediaPlayerTappableView.swift

import SwiftUI

struct MediaPlayerTappableView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        HStack(spacing: .zero) {
            renderTappableScreen(.backward)
            renderControlsTriggerLayer()
            renderTappableScreen(.forward)
        }
    }

    @ViewBuilder func renderControlsTriggerLayer() -> some View {
        Rectangle()
            .foregroundColor(.clear)
            .contentShape(Rectangle())
            .frame(width: Constants.tappableControlScreenWidth)
            .onTapGesture {
                viewModel.onTapControlsTriggerArea()
            }
    }

    @ViewBuilder private func renderTappableScreen(_ seek: Seek) -> some View {
        ZStack {
            renderSeekTapsDetector(seek)
            renderSeekIcon(seek)
        }
    }

    @ViewBuilder func renderSeekTapsDetector(_ seek: Seek) -> some View {
        Rectangle()
            .foregroundColor(.clear)
            .contentShape(Rectangle())
            .onTapGesture {
                viewModel.onTapSeekArea(seek)
            }
    }

    @ViewBuilder func renderSeekIcon(_ seek: Seek) -> some View {
        if viewModel.seekState.visibleSeek == seek {
            seek.systemImage
                .resizable()
                .frame(width: Constants.iconSize.width, height: Constants.iconSize.height)
                .foregroundColor(.white)
        }
    }
}

extension MediaPlayerTappableView {
    class ViewModel: ObservableObject {
        let seekState: SeekState
        let isSeekByTapEnabled: Bool

        let onTapSeekArea: (Seek) -> Void
        let onTapControlsTriggerArea: () -> Void

        var timer: Timer?

        init(
            seekState: SeekState,
            isSeekByTapEnabled: Bool,
            onTapSeekArea: @escaping (Seek) -> Void,
            onTapControlsTriggerArea: @escaping () -> Void
        ) {
            self.seekState = seekState
            self.isSeekByTapEnabled = isSeekByTapEnabled
            self.onTapSeekArea = onTapSeekArea
            self.onTapControlsTriggerArea = onTapControlsTriggerArea
        }
    }
}

extension MediaPlayerTappableView {
    enum Constants {
        static let iconSize: CGSize = .init(width: 30, height: 20)
        static let doubleTap: Int = 2
        static let singleTap: Int = 1
        static let showSeekDelay: TimeInterval = 0.5
        static let tappableControlScreenWidth: CGFloat = 120
    }
}

extension MediaPlayerTappableView {
    enum Seek {
        case backward
        case forward

        var systemImage: Image {
            switch self {
            case .backward:
                return Image(systemName: Constants.rewindIcon)
            case .forward:
                return Image(systemName: Constants.forwardIcon)
            }
        }
    }
}

extension MediaPlayerTappableView {
    enum SeekState {
        case none
        case ready(Seek)
        case seeking(Seek)

        var seek: Seek? {
            switch self {
            case .none:
                return nil
            case .ready(let seek), .seeking(let seek):
                return seek
            }
        }

        var visibleSeek: Seek? {
            switch self {
            case .none, .ready:
                return nil
            case .seeking(let seek):
                return seek
            }
        }
    }
}

extension MediaPlayerTappableView.Seek {
    enum Constants {
        static let rewindIcon = "backward.fill"
        static let forwardIcon = "forward.fill"
    }
}
