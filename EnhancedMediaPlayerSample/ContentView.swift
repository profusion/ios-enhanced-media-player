// ContentView.swift

import SwiftUI
import EnhancedMediaPlayer

struct ContentView: View {
    @State private var selected: MediaType = .remoteVideo

    @StateObject private var preferences: SettingsPreferences = .init()

    var body: some View {
        VStack(spacing: .zero) {
            MediaPlayer(url: URL(string: selected.url)!)
                .frame(height: 300)

            Picker(Constants.pickerLabel, selection: $selected) {
                Text(MediaType.streamVideo.label).tag(MediaType.streamVideo)
                Text(MediaType.remoteVideo.label).tag(MediaType.remoteVideo)
                Text(MediaType.remoteMusic.label).tag(MediaType.remoteMusic)
            }
            .pickerStyle(.segmented)
        }
        .sheet(isPresented: $preferences.isShowingSettingsMenu) {
            SettingsMenu()
        }
        .environmentObject(preferences)
    }
}


extension ContentView {
    enum Constants {
        static let pickerLabel = "Choose media option"
        static let streamVideo = "Stream Video"
        static let remoteVideo = "Remote Video"
        static let remoteMusic = "Remote Music"
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
        
        var label: String {
            switch self {
            case .streamVideo: return Constants.streamVideo
            case .remoteVideo: return Constants.remoteVideo
            case .remoteMusic: return Constants.remoteMusic
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
