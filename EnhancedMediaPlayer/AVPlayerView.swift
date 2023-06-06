// AVPlayerView.swift

import AVKit
import SwiftUI

public struct AVPlayerView: UIViewControllerRepresentable {
    private let player: AVPlayer
    private let playerState: MediaPlayerView.PlayerState

    init(player: AVPlayer, playerState: MediaPlayerView.PlayerState) {
        self.player = player
        self.playerState = playerState
    }

    public func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerController = AVPlayerViewController()
        setupPlayerController(playerController)
        updatePlayerState(playerController)
        return playerController
    }

    public func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        if let currentURL = playerController.player?.currentItem?.asset as? AVURLAsset,
           let newURL = player.currentItem?.asset as? AVURLAsset,
           currentURL != newURL {
            setupPlayerController(playerController)
        }
        updatePlayerState(playerController)
    }

    private func setupPlayerController(_ playerController: AVPlayerViewController) {
        playerController.showsPlaybackControls = false
        playerController.player = player
    }
    
    private func updatePlayerState(_ playerController: AVPlayerViewController) {
        switch playerState {
            case .playing: playerController.player?.play()
            default: playerController.player?.pause()
        }
    }
}
