// MediaPlayer.swift

import SwiftUI

public struct MediaPlayer: UIViewControllerRepresentable {
    private let mediaURL: URL
    private let seekFactor: TimeInterval
    private let preferences: SettingsPreferences
    
    public init(url mediaURL: URL, seekFactor: TimeInterval, preferences: SettingsPreferences) {
        self.mediaURL = mediaURL
        self.seekFactor = seekFactor
        self.preferences = preferences
    }
    
    public func makeUIViewController(context: Context) -> MediaPlayerViewController {
        let mediaPlayerController = MediaPlayerViewController(mediaURL: mediaURL, seekFactor: seekFactor, preferences: preferences)
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
