// ContentView.swift

import SwiftUI
import EnhancedMediaPlayer

struct ContentView: View {
    @State private var selected: MediaType = .remoteVideo

    var body: some View {
        VStack(spacing: .zero) {
            MediaPlayer(url: URL(string: selected.url)!)
                .frame(height: 300)

            Picker(selection: $selected, label: Text("Choose media option")) {
                Text("Stream video").tag(MediaType.streamVideo)
                Text("Remote video").tag(MediaType.remoteVideo)
                Text("Remote music").tag(MediaType.remoteMusic)
            }
            .pickerStyle(.segmented)
        }
    }
}

extension ContentView {
    enum MediaType {
        case streamVideo
        case remoteVideo
        case remoteMusic
        
        var url: String {
            switch self {
            case .streamVideo:
                return "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8"
            case .remoteVideo:
                return "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4"
            case .remoteMusic:
                return "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-17.mp3"
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
