//  MediaPlayerControllerRepresentable.swift

import AVKit
import SwiftUI

public struct MediaPlayerControllerRepresentable: UIViewControllerRepresentable {
    @ObservedObject private var playerManager: PlayerManager
    private let mediaURL: URL

    init(mediaURL: URL) {
        self.mediaURL = mediaURL
        self.playerManager = .init(playerController: .init())
    }

    public func makeUIViewController(context: Context) -> AVPlayerViewController {
        setupPlayerController(playerManager.playerController)

        return playerManager.playerController
    }

    public func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        if let currentURL = playerController.player?.currentItem?.asset as? AVURLAsset,
           currentURL.url != mediaURL {
            playerManager.playerController = playerController
            setupPlayerController(playerManager.playerController)
        }
    }

    func play() {
        playerManager.playerController.player?.play()
    }

    func pause() {
        playerManager.playerController.player?.pause()
    }

    func replay() {
        playerManager.playerController.player?.seek(to: CMTime.zero)
        playerManager.playerController.player?.play()
    }

    func observePlayToEnd(onEnd action: @escaping () -> Void) {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: playerManager.playerController.player?.currentItem,
            queue: nil
        ) { _ in
           action()
        }
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }

    private func setupPlayerController(_ playerController: AVPlayerViewController) {
        playerController.showsPlaybackControls = false
        playerController.player = AVPlayer(url: mediaURL)
        playerController.player?.play()
    }
}

extension MediaPlayerControllerRepresentable {
    class PlayerManager: ObservableObject {
        var playerController: AVPlayerViewController
        
        init(playerController: AVPlayerViewController) {
            self.playerController = playerController
        }
    }
}
