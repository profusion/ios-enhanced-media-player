// MediaPlayerViewController.swift

import SwiftUI
import AVFoundation

public class MediaPlayerViewController: UIHostingController<MediaPlayerView> {
    private let viewModel: MediaPlayerView.ViewModel

    private var tapTimer: Timer?

    public init(mediaURL: URL, seekFactor: TimeInterval) {
        viewModel = .init(player: .init(url: mediaURL), seekFactor: seekFactor)

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

        viewModel.onTapSeekArea = { [weak self] seek in
            guard let self else { return }

            Task {
                self.onTapSeekArea(seek)
            }
        }

        viewModel.onTapControlsTriggerArea = { [weak self] in
            guard let self else { return }

            switch viewModel.seekState {
            case .none, .ready:
                viewModel.areControlsVisible.toggle()
            case .seeking:
                break
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
        seek(forward: false)
    }
    
    private func forward() {
        seek(forward: true)
    }

    private func seek(forward: Bool) {
        let current = viewModel.player.currentTime().seconds
        let target: Double = forward ? current + viewModel.seekFactor : current - viewModel.seekFactor
        let result: CMTime =  .init(seconds: target, preferredTimescale: Constants.timeScale)
        viewModel.player.seek(to: result)
    }

    private func onLoad() {
        play()
        observeMediaFinished()
    }

    private func onTapSeekArea(_ seek: MediaPlayerTappableView.Seek) {
        guard viewModel.isSeekByTapEnabled else {
            viewModel.areControlsVisible.toggle()
            return
        }

        tapTimer?.invalidate()

        switch viewModel.seekState {
        case .none:
            viewModel.seekState = .ready(seek)
            startResetSeekStateToDefaultTimer()
        case .ready, .seeking:
            viewModel.seekState = .seeking(seek)
            viewModel.areControlsVisible = false
            startSeekTerminationTimer()
            performSeek(seek)
        }
    }

    private func performSeek(_ seek: MediaPlayerTappableView.Seek) {
        switch seek {
        case .backward:
            rewind()
        case .forward:
            forward()
        }
    }

    private func startSeekTerminationTimer() {
        tapTimer = Timer.scheduledTimer(withTimeInterval: Constants.seekTapInterval, repeats: false) { _ in
            self.viewModel.seekState = .none
        }
    }

    private func startResetSeekStateToDefaultTimer() {
        tapTimer = Timer.scheduledTimer(withTimeInterval: Constants.showControlsDelay, repeats: false) { _ in
            guard case .ready = self.viewModel.seekState else { return }

            self.viewModel.areControlsVisible.toggle()
            self.viewModel.seekState = .none
        }
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

extension MediaPlayerViewController {
    enum Constants {
        static let timeScale: CMTimeScale = 1
        static let seekTapInterval: Double = 1
        static let seekTapAnimationInterval: Double = 0.3
        static let showControlsDelay: Double = 0.5
    }
}
