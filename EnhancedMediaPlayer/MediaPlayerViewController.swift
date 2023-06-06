//  MediaPlayerViewController.swift

import SwiftUI

class MediaPlayerViewController: UIHostingController<MediaPlayerView> {
    private let playerViewHandler: MediaPlayerControllerRepresentable
    private let viewModel: MediaPlayerView.ViewModel

    init(mediaURL: URL) {
        self.viewModel = .init()
        self.playerViewHandler = .init(mediaURL: mediaURL)

        super.init(rootView: .init(viewModel: viewModel))
        
        self.viewModel.playerViewHandler = playerViewHandler
        self.viewModel.playerState = .playing

        setupActions()
        observePlayToEnd()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }

    required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupActions() {
        viewModel.onTapAction = { [weak self] control in
            guard let self else { return }
            
            switch control {
                case .play: self.play()
                case .pause: self.pause()
                case .replay: self.replay()
                case .rewind: self.rewind()
                case .forward: self.forward()
            }
        }
    }
    
    private func observePlayToEnd() {
        self.playerViewHandler.observePlayToEnd {
            self.viewModel.playerState = .finished
        }
    }
    
    private func removeObserver() {
        self.playerViewHandler.removeObserver()
    }
    
    private func play() {
        self.viewModel.playerState = .playing
        self.playerViewHandler.play()
    }
    
    private func pause() {
        self.viewModel.playerState = .paused
        self.playerViewHandler.pause()
    }
    
    private func replay() {
        // TODO: implement replay
    }
    
    private func rewind() {
        // TODO: implement rewind
    }
    
    private func forward() {
        // TODO: implement forward
    }
}
