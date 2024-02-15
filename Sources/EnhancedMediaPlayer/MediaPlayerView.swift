// MediaPlayerView.swift

import SwiftUI
import AVFoundation

public struct MediaPlayerView: View {
    @ObservedObject var viewModel: MediaPlayerView.ViewModel
    @State private var screenWidth: CGFloat = .zero
    
    public init(viewModel: MediaPlayerView.ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            AVPlayerView(player: viewModel.player, playerState: viewModel.playerState)

            MediaPlayerTappableView(viewModel: .init(
                seekState: viewModel.seekState,
                isSeekByTapEnabled: viewModel.isSeekByTapEnabled,
                onTapSeekArea: { seek in viewModel.onTapSeekArea?(seek) },
                onTapControlsTriggerArea: { viewModel.onTapControlsTriggerArea?() }
            ))

            if viewModel.areControlsVisible {
                MediaPlayerControlsView(viewModel: .init(
                    screenWidth: $screenWidth,
                    playerState: $viewModel.playerState,
                    seekFactor: viewModel.seekFactor,
                    inLoopEnabled: viewModel.inLoopEnabled,
                    currentElapsedTime: $viewModel.currentElapsedTimeBinding,
                    mediaTotalTime: viewModel.mediaTotalTime,
                    onTapAction: { control in viewModel.onTapAction?(control) }
                ))
            }
        }
        .readFrame { size in
            screenWidth = size.width
        }
    }
}

extension MediaPlayerView {
    public class ViewModel: ObservableObject {
        @Published var isSeekByTapEnabled: Bool = true
        @Published var playerState: PlayerState = .loading
        @Published var inLoopEnabled: Bool = false
        @Published var seekState: MediaPlayerTappableView.SeekState = .none
        @Published var areControlsVisible: Bool = false
        @Published var player: AVPlayer
        @Published var videoCurrentTime: Double = .zero

        var currentElapsedTimeBinding: Double {
            get {
                player.status == .readyToPlay ? videoCurrentTime : Constants.fallbackDuration
            }
            set {
                player.seek(
                    to: .init(seconds: newValue, preferredTimescale: Constants.defaultTimeScale),
                    toleranceBefore: .zero,
                    toleranceAfter: .zero
                )
            }
        }

        var mediaTotalTime: Double {
            guard let duration = player.currentItem?.duration.seconds, !duration.isNaN else {
                return Constants.fallbackDuration
            }
            return duration
        }

        var onTapAction: ((MediaPlayerControlsView.Control) -> Void)?
        var onTapSeekArea: ((MediaPlayerTappableView.Seek) -> Void)?
        var onTapControlsTriggerArea: (() -> Void)?

        let seekFactor: TimeInterval

        init(player: AVPlayer, seekFactor: TimeInterval) {
            self.player = player
            self.seekFactor = seekFactor
        }
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
    enum Constants {
        static let defaultTimeScale: CMTimeScale = 30
        static let fallbackDuration: TimeInterval = .zero
    }
}

#if DEBUG
struct MediaPlayerView_Previews: PreviewProvider {
    static let testURL =  URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4")!
    static var previews: some View {
        MediaPlayerView(viewModel: .init(
            player: .init(url: testURL),
            seekFactor: 10
        ))
    }
}
#endif
