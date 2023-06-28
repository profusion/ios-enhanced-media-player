// MediaPlayerControlsView.swift

import SwiftUI

struct MediaPlayerControlsView: View {
    @ObservedObject var viewModel: ViewModel

    @EnvironmentObject var preferences: SettingsPreferences

    var body: some View {
        renderOverlay()
        renderActionButtons()
            .padding(.horizontal, viewModel.screenWidth / Constants.paddingWidthDivider)
    }

    @ViewBuilder private func renderOverlay() -> some View {
        Rectangle()
            .fill(.black)
            .opacity(Constants.overlayOpacity)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder private func renderActionButtons() -> some View {
        VStack(spacing: .zero) {
            renderLoop()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack(spacing: .zero) {
                renderRewind()
                    .frame(maxWidth: .infinity, alignment: .leading)
                renderMainButtonState()
                renderForward()
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity)
            renderButton(control: .settings, size: Constants.settingsIconSize)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
        }
    }

    @ViewBuilder private func renderMainButtonState() -> some View {
        switch viewModel.playerState {
            case .playing: renderButton(control: .pause)
            case .paused, .loading: renderButton(control: .play)
            case .finished: renderButton(control: .replay)
        }
    }

    @ViewBuilder private func renderLoop() -> some View {
        renderButton(control: .loop, color: viewModel.inLoopEnabled ? .blue : .white)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }

    @ViewBuilder private func renderPlayPause() -> some View {
        renderButton(control: viewModel.playerState == .playing ? .pause : .play)
    }

    @ViewBuilder private func renderReplay() -> some View {
        renderButton(control: .replay)
    }

    @ViewBuilder private func renderRewind() -> some View {
        renderTimePlaceholderWrapper {
            renderButton(control: .rewind)
        }
    }

    @ViewBuilder private func renderForward() -> some View {
        renderTimePlaceholderWrapper {
            renderButton(control: .forward)
        }
    }

    @ViewBuilder private func renderButton(
        control: Control,
        color: Color = .white,
        size: CGFloat = Constants.iconFontSize
    ) -> some View {
        control.systemImage
            .font(.system(size: size))
            .tint(color)
            .wrapInButton {
                handleControl(control)
            }
    }

    @ViewBuilder private func renderTimePlaceholderWrapper<Content: View>(
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            content()
            Text(viewModel.formattedSeekFactor)
                .foregroundColor(.white)
                .font(.system(size: Constants.timeFontSize))
        }
    }

    private func handleControl(_ control: Control) {
        // Not very ideal to do this, but as mentioned, we're abusing UIKit + SwiftUI...
        guard control != .settings else {
            preferences.isShowingSettingsMenu.toggle()
            return
        }

        viewModel.onTapAction(control)
    }
}

extension MediaPlayerControlsView {
    class ViewModel: ObservableObject {
        @Binding var screenWidth: CGFloat
        @Binding var playerState: MediaPlayerView.PlayerState

        let inLoopEnabled: Bool
        let seekFactor: TimeInterval

        let onTapAction: (Control) -> Void

        var formattedSeekFactor: String {
            seekFactor.truncatingRemainder(dividingBy: 1) == 0 ?
                String(format: Constants.seekFactorFormat, seekFactor) :
                String(format: Constants.seekFactorDecimalFormat, seekFactor)
        }

        init(
            screenWidth: Binding<CGFloat>,
            playerState: Binding<MediaPlayerView.PlayerState>,
            seekFactor: TimeInterval,
            inLoopEnabled: Bool,
            onTapAction: @escaping ((Control) -> Void)
        ) {
            self._screenWidth = screenWidth
            self._playerState = playerState
            self.seekFactor = seekFactor
            self.inLoopEnabled = inLoopEnabled
            self.onTapAction = onTapAction
        }
    }
}

extension MediaPlayerControlsView {
    enum Constants {
        static let timeFontSize: CGFloat = 12
        static let iconSize: CGSize = .init(width: 30, height: 30)
        static let paddingWidthDivider: CGFloat = 6
        static let overlayOpacity: CGFloat = 0.3
        static let seekFactorFormat: String = "%.0fs"
        static let seekFactorDecimalFormat: String = "%.1fs"
        static let iconFontSize: CGFloat = 40
        static let settingsIconSize: CGFloat = 20
    }
}

extension MediaPlayerControlsView {
    enum Control {
        case play
        case pause
        case loop
        case replay
        case rewind
        case forward
        case settings

        var systemImage: Image {
            switch self {
            case .play:
                return Image(systemName: Constants.playIcon)
            case .pause:
                return Image(systemName: Constants.pauseIcon)
            case .loop:
                return Image(systemName: Constants.loopIcon)
            case .replay:
                return Image(systemName: Constants.replayIcon)
            case .rewind:
                return Image(systemName: Constants.rewindIcon)
            case .forward:
                return Image(systemName: Constants.forwardIcon)
            case .settings:
                return Image(systemName: Constants.settingsIcon)
            }
        }
    }
}

extension MediaPlayerControlsView.Control {
    enum Constants {
        static let playIcon = "play.fill"
        static let pauseIcon = "pause.fill"
        static let loopIcon = "infinity"
        static let replayIcon = "repeat"
        static let forwardIcon = "goforward"
        static let rewindIcon = "gobackward"
        static let settingsIcon = "gearshape.fill"
    }
}