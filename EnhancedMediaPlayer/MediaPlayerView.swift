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
        HStack(spacing: .zero) {
            renderRewind()
                .frame(maxWidth: .infinity, alignment: .leading)
            if viewModel.playerState == .finished {
                renderReplay()
            } else {
                renderPlayPause()
            }
            renderForward()
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder private func renderPlayPause() -> some View {
        renderButton(control: viewModel.playerState == .playing ? .pause : .play)
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
    
    @ViewBuilder private func renderButton(control: Control) -> some View {
        control.systemImage
            .resizable()
            .frame(width: Constants.iconSize.width, height: Constants.iconSize.height)
            .foregroundColor(.white)
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
        }
    }
}

extension MediaPlayerView {
    public class ViewModel: ObservableObject {
        @Published var playerState: PlayerState = .loading
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
        case replay
        case rewind
        case forward
        
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
