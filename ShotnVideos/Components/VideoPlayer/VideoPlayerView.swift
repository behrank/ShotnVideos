//
//  VideoPlayerView.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 27.05.2021.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    lazy private var closeBtn: CircleButton         = { return CircleButton(width: 36,
                                                                            height: 36,
                                                                            imageName: "close") }()
    lazy private var playBtn: CircleButton      = { return CircleButton(width: 42,
                                                                        height: 42,
                                                                        imageName: "play") }()
    private var playStatus: VideoPlayStatus = .stopped {
        didSet {
            Queue.main.execute {
                let imageName = self.playStatus == .playing ? "pause" : "play"
                self.playBtn.setImage(UIImage(named: imageName),
                                 for: .normal)
                
                if self.playStatus == .playing {
                    self.player?.play()
                } else {
                    self.player?.pause()
                }
            }
        }
    }
    
    var player: AVPlayer?
    private var currentShot: ShotObject?
    
    func setup(for shot: ShotObject, isCloseRequired: Bool = false) {
        currentShot = shot
        
        fillSuperview()
        addSubviews(views: playBtn)
        
        backgroundColor = .black
        isHidden = true
        
        playBtn.setMargins(.bottom(value: 84))
        playBtn.anchorCenterXToSuperview()
        
        playBtn.addTarget(self,
                          action: #selector(playButtonTapped),
                          for: .touchUpInside)
        
        if isCloseRequired {
            addSubviews(views: closeBtn)
            closeBtn.addTarget(self,
                               action: #selector(userTappedClose),
                               for: .touchUpInside)
            
            closeBtn.setMargins(.top(value: 44),
                                .left(value: 12))
        }
    }
    
    func display() {
        
        guard let currentShot = currentShot else {
            return
        }
        
        let window = UIApplication.shared.windows.first
        window?.addSubviews(views: self)
        
        fillSuperview()
        makeVideoPlayable(for: currentShot.getVideoUrl())
        
        isHidden = false
    }
    
    func makeVideoPlayable(for url: URL?) {
        
        guard let videoUrl = url else {
            return
        }
        
        player = AVPlayer(url: videoUrl)
        
        let avPlayerLayer: AVPlayerLayer = AVPlayerLayer(player: player)
        avPlayerLayer.frame = UIScreen.main.bounds
        
        layer.addSublayer(avPlayerLayer)
        bringSubviewToFront(playBtn)
        
        isHidden = false
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: self.player?.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.playStatus = .stopped
        }
        
        debugPrint("player ready")

    }
    
    // MARK: Private
    @objc private func playButtonTapped() {
        if playStatus == .stopped {
            playStatus = .playing
        } else {
            playStatus = .stopped
        }
    }
    
    @objc private func userTappedClose() {
        player = nil
        isHidden = true
        removeFromSuperview()
    }
}
