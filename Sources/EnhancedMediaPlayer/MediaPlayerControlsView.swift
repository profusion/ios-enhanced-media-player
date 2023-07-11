// MediaPlayerControlsView.swift

import SwiftUI

struct MediaPlayerControlsView: View {
    @ObservedObject var viewModel: ViewModel

    @EnvironmentObject var preferences: SettingsPreferences

    var body: some View {
        renderOverlay()
        renderActionButtons()
        renderButtonBar()
    }

    @ViewBuilder private func renderOverlay() -> some View {
        Rectangle()
            .fill(.black)
            .opacity(Constants.overlayOpacity)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder private func renderActionButtons() -> some View {
        HStack(spacing: Constants.defaultPadding) {
            renderRewind()
            renderMainButtonState()
            renderForward()
        }
        .frame(maxHeight: .infinity)
    }

    @ViewBuilder private func renderButtonBar() -> some View {
        HStack(spacing: Constants.defaultPadding) {
            renderTimeBar()
            renderLoop()
            renderButton(control: .settings, size: Constants.accessoryButtonSize)
        }
        .padding(Constants.defaultPadding)
        .frame(maxWidth: .infinity)
        .background(Constants.bottomBarColor)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }

    @ViewBuilder private func renderMainButtonState() -> some View {
        switch viewModel.playerState {
            case .playing: renderButton(control: .pause)
            case .paused, .loading: renderButton(control: .play)
            case .finished: renderButton(control: .replay)
        }
    }

    @ViewBuilder private func renderLoop() -> some View {
        renderButton(control: .loop, color: viewModel.inLoopEnabled ? .blue : .white, size: Constants.accessoryButtonSize)
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
        size: CGFloat = Constants.primaryButtonSize
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

    @ViewBuilder private func renderTimeBar(color: Color = .blue) -> some View {
        Slider(value: $viewModel.currentElapsedTime, in: .zero...viewModel.mediaTotalTime) {
            // No label needed for now
        } minimumValueLabel: {
            Text(Date.mediaTime(viewModel.currentElapsedTime, totalTimeInSeconds: viewModel.mediaTotalTime))
                .foregroundColor(.white)
                .font(.system(size: Constants.timeFontSize))
        } maximumValueLabel: {
            Text(Date.mediaTime(viewModel.mediaTotalTime, totalTimeInSeconds: viewModel.mediaTotalTime))
                .foregroundColor(.white)
                .font(.system(size: Constants.timeFontSize))
        }
        .tint(color)
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
        @Binding var currentElapsedTime: TimeInterval

        let inLoopEnabled: Bool
        let seekFactor: TimeInterval
        let mediaTotalTime: TimeInterval

        let onTapAction: (Control) -> Void

        var formattedSeekFactor: String {
            seekFactor.truncatingRemainder(dividingBy: 1) == .zero ?
                String(format: Constants.seekFactorFormat, seekFactor) :
                String(format: Constants.seekFactorDecimalFormat, seekFactor)
        }

        init(
            screenWidth: Binding<CGFloat>,
            playerState: Binding<MediaPlayerView.PlayerState>,
            seekFactor: TimeInterval,
            inLoopEnabled: Bool,
            currentElapsedTime: Binding<TimeInterval>,
            mediaTotalTime: TimeInterval,
            onTapAction: @escaping ((Control) -> Void)
        ) {
            self._screenWidth = screenWidth
            self._playerState = playerState
            self._currentElapsedTime = currentElapsedTime
            self.mediaTotalTime = mediaTotalTime
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
        static let primaryButtonSize: CGFloat = 40
        static let accessoryButtonSize: CGFloat = 24
        static let defaultPadding: CGFloat = 16
        static let bottomBarColor: Color = .black.opacity(0.70)
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
