// MediaPlayer.swift

import SwiftUI

public struct MediaPlayer: UIViewControllerRepresentable {
    private let mediaURL: URL
    private let seekFactor: TimeInterval
    
    public init(url mediaURL: URL, seekFactor: TimeInterval) {
        self.mediaURL = mediaURL
        self.seekFactor = seekFactor
    }
    
    public func makeUIViewController(context: Context) -> MediaPlayerViewController {
        let mediaPlayerController = MediaPlayerViewController(mediaURL: mediaURL, seekFactor: seekFactor)
        return mediaPlayerController
    }

    public func updateUIViewController(_ mediaPlayerController: MediaPlayerViewController, context: Context) {
        Task {
            await MainActor.run {
                mediaPlayerController.updateURL(with: mediaURL)
            }
        }
    }
}
