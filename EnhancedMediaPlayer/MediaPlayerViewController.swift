// MediaPlayerViewController.swift

import SwiftUI
import AVFoundation

public class MediaPlayerViewController: UIHostingController<MediaPlayerView> {
    private let viewModel: MediaPlayerView.ViewModel

    public init(mediaURL: URL) {
        self.viewModel = .init(player: .init(url: mediaURL))

        super.init(rootView: .init(viewModel: viewModel))

        setupActions()
    }

    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        onLoad()
    }

    func updateURL(with mediaURL: URL) {
        viewModel.player = .init(url: mediaURL)
        onLoad()
    }

    private func setupActions() {
        viewModel.onTapAction = { [weak self] control in
            guard let self else { return }
            
            switch control {
                case .play: self.play()
                case .pause: self.pause()
                case .loop: self.loop()
                case .replay: self.replay()
                case .rewind: self.rewind()
                case .forward: self.forward()
                case .settings: break
            }
        }
    }
    
    private func play() {
        self.viewModel.playerState = .playing
    }
    
    private func pause() {
        self.viewModel.playerState = .paused
    }

    private func loop() {
        self.viewModel.inLoopEnabled.toggle()
    }
    
    private func replay() {
        self.viewModel.player.seek(to: CMTime.zero)
        self.viewModel.playerState = .playing
    }
    
    private func rewind() {
        // TODO: implement rewind
    }
    
    private func forward() {
        // TODO: implement forward
    }

    private func onLoad() {
        play()
        observeMediaFinished()
    }
    
    private func observeMediaFinished() {
        self.removeObserver()

        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: viewModel.player.currentItem,
            queue: nil
        ) { _ in
            if self.viewModel.inLoopEnabled {
                self.replay()
                self.viewModel.player.play()
            } else {
                self.viewModel.playerState = .finished
            }
        }
    }

    private func removeObserver() {
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }
}

