// MediaPlayerView.swift

import SwiftUI
import AVFoundation

public struct MediaPlayerView: View {
    @ObservedObject var viewModel: MediaPlayerView.ViewModel
    @State private var showActionButtons = false
    @State private var screenWidth: CGFloat = .zero
    
    public init(viewModel: MediaPlayerView.ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            AVPlayerView(player: viewModel.player, playerState: viewModel.playerState)
            
            if showActionButtons {
                renderOverlay()
                renderActionButtons()
                    .padding(.horizontal, screenWidth / Constants.paddingWidthDivider)
            }
        }
        .onTapGesture {
            withAnimation {
                showActionButtons.toggle()
            }
        }
        .readFrame { size in
            screenWidth = size.width
        }
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
                    .disabled(viewModel.playerState == .finished)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity)
            Spacer()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    
    @ViewBuilder private func renderReplay() -> some View {
        renderButton(control: .replay)
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
    
    @ViewBuilder private func renderButton(control: Control, color: Color = .white) -> some View {
        control.systemImage
            .font(.system(size: Constants.iconFontSize))
            .tint(color)
            .wrapInButton(action: { viewModel.onTapAction?(control) })
    }
    
    @ViewBuilder private func renderTimeElapsedWrapper<Content: View>(
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            content()
            Text("10") // TODO: update with amount of rewind / forward
                .foregroundColor(.white)
                .font(.system(size: Constants.timeFontSize))
                .frame(width: Constants.iconSize.width, height: Constants.iconSize.height)
        }
    }
}

extension MediaPlayerView {
    public class ViewModel: ObservableObject {
        @Published var playerState: PlayerState = .loading
        @Published var inLoopEnabled: Bool = false
        @Published var player: AVPlayer

        var onTapAction: ((Control) -> Void)?
        
        init(player: AVPlayer) {
            self.player = player
        }
    }
}

extension MediaPlayerView {
    enum Constants {
        static let timeFontSize: CGFloat = 12
        static let iconFontSize: CGFloat = 40.0
        static let iconSize: CGSize = .init(width: 30, height: 30)
        static let paddingWidthDivider: CGFloat = 6
        static let overlayOpacity: CGFloat = 0.3
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
        case loop
        case replay
        case rewind
        case forward
        
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
            }
        }
    }
}

extension MediaPlayerView.Control {
    enum Constants {
        static let playIcon = "play.fill"
        static let pauseIcon = "pause.fill"
        static let loopIcon = "infinity"
        static let replayIcon = "repeat"
        static let forwardIcon = "goforward"
        static let rewindIcon = "gobackward"
    }
}

#if DEBUG
struct MediaPlayerView_Previews: PreviewProvider {
    static let testURL =  URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4")!
    static var previews: some View {
        MediaPlayerView(viewModel: .init(player: .init(url: testURL)))
    }
}
#endif
