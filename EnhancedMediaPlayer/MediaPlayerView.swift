// MediaPlayerView.swift

import SwiftUI

struct MediaPlayerView: View {
    @ObservedObject var viewModel: MediaPlayerView.ViewModel
    
    init(viewModel: MediaPlayerView.ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                viewModel.playerViewHandler
                
                if viewModel.shouldRenderOverlay {
                    renderOverlay()
                    renderActionButtons()
                        .padding(.horizontal, geometry.size.width / Constants.paddingWidthDivider)
                }
            }
            .onTapGesture {
                withAnimation {
                    viewModel.handleTapOnPlayer()
                }
            }
        }
    }
    
    @ViewBuilder private func renderOverlay() -> some View {
        Rectangle()
            .fill(.black)
            .opacity(Constants.overlayOpacity)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder private func renderActionButtons() -> some View {
        ZStack {
            VStack {
                HStack {
                    // TODO: implment ActionButtons top row
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                HStack {
                    renderRewind()
                    Spacer()
                    renderPlayPauseReplay()
                    Spacer()
                    renderForward()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                HStack {
                    renderSettings()
                        .padding(.bottom, Constants.settingsIconPadding)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }

            if viewModel.showSettingsMenu {
               SettingsMenu()
                    .padding(.bottom, Constants.settingsMenuPadding)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
        }
    }
    
    @ViewBuilder private func renderPlayPauseReplay() -> some View {
        switch viewModel.playerState {
            case .playing: renderButton(control: .pause)
            case .paused: renderButton(control: .play)
            case .finished: renderButton(control: .replay)
            case .loading: renderButton(control: .play)
        }
    }
    
    @ViewBuilder private func renderRewind() -> some View {
        renderTimeElapsedWrapper {
            renderButton(control: .rewind)
        }
    }
    
    @ViewBuilder private func renderForward() -> some View {
        renderTimeElapsedWrapper {
            renderButton(control: .forward)
        }
    }
    
    @ViewBuilder private func renderSettings() -> some View {
        renderButton(control: .settings)
    }

    @ViewBuilder private func renderButton(control: Control) -> some View {
        Button(action: { viewModel.onTapAction?(control) }) {
            control.systemImage
                .resizable()
                .frame(width: Constants.iconSize.width, height: Constants.iconSize.height)
                .foregroundColor(.white)
        }
    }
    
    @ViewBuilder private func renderTimeElapsedWrapper<Content: View>(
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            content()
            Text("10") // TODO: update with amount of rewind / forward
                .foregroundColor(.white)
                .font(.system(size: Constants.timeFontSize))
        }
    }
}

extension MediaPlayerView {
    class ViewModel: ObservableObject {
        @Published var playerState: PlayerState = .loading
        @Published var showSettingsMenu = false
        @Published var shouldRenderOverlay = false
        
        var playerViewHandler: MediaPlayerControllerRepresentable?

        var onTapAction: ((Control) -> Void)?
        
        func handleTapOnPlayer() {
            if showSettingsMenu {
                showSettingsMenu.toggle()
            } else {
                shouldRenderOverlay.toggle()
            }
        }
    }
}

extension MediaPlayerView {
    enum Constants {
        static let timeFontSize: CGFloat = 12
        static let iconSize: CGSize = .init(width: 30, height: 30)
        static let paddingWidthDivider: CGFloat = 6
        static let overlayOpacity: CGFloat = 0.3
        static let settingsIconPadding: CGFloat = 8.0
        static let settingsMenuPadding: CGFloat = 40.0
    }
}

extension MediaPlayerView {
    enum PlayerState: Equatable {
        case playing
        case paused
        case finished
        case loading
    }
}

extension MediaPlayerView {
    enum Control {
        case play
        case pause
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

extension MediaPlayerView.Control {
    enum Constants {
        static let playIcon = "play.fill"
        static let pauseIcon = "pause.fill"
        static let replayIcon = "repeat"
        static let forwardIcon = "goforward"
        static let rewindIcon = "gobackward"
        static let settingsIcon = "gearshape.fill"
    }
}

#if DEBUG
struct MediaPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MediaPlayerView(viewModel: .init())
    }
}
#endif
