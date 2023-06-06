// MediaPlayer.swift

import SwiftUI

public struct MediaPlayer: View {
    private var mediaURL: URL
    
    public init(url mediaURL: URL) {
        self.mediaURL = mediaURL
    }
    
    public var body: some View {
        MediaPlayerViewController(mediaURL: mediaURL).rootView
    }
}

#if DEBUG
struct MediaPlayer_Previews: PreviewProvider {
    static let testUrl = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    static var previews: some View {
        MediaPlayer(url: URL(string: testUrl)!)
    }
}
#endif
