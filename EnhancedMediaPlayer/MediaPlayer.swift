// MediaPlayer.swift

import SwiftUI

public struct MediaPlayer: UIViewControllerRepresentable {
    private let mediaURL: URL
    
    public init(url mediaURL: URL) {
        self.mediaURL = mediaURL
    }
    
    public func makeUIViewController(context: Context) -> MediaPlayerViewController {
        let mediaPlayerController = MediaPlayerViewController(mediaURL: mediaURL)
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
