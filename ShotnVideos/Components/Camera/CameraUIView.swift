//
//  CameraUIView.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import UIKit
import AVFoundation

private enum FlashStatus {
    case on, off
}

class CameraUIView: UIView {
    
    lazy private var previewImageView: UIImageView  = { return UIImageView(frame: .zero) }()
    lazy private var flashBtn: UIButton             = { return UIButton(frame: .zero) }()
    lazy private var rotateView: UIView             = { return UIView(frame: .zero) }()
    lazy private var captureBtn: UIButton           = { return UIButton(frame: .zero) }()
    lazy private var previewImage: UIImageView      = { return UIImageView(frame: .zero) }()
    lazy private var captureTimeLabel: UILabel      = { return UILabel(frame: .zero) }()
    lazy private var overlayView: CameraOverlay     = { return CameraOverlay() }()
    lazy private var closeBtn: CircleButton         = { return CircleButton(width: 36,
                                                                            height: 36,
                                                                            imageName: "close") }()
    private var playerView: VideoPlayerView?

    var onCloseTapped: (()->Void)?
    
    init(shot: ShotObject) {
        super.init(frame: .zero)
        setupUI(shot)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(_ shot: ShotObject) {
        
        playerView = VideoPlayerView()
        
        guard let playerView = playerView else {
            return
        }
        
        addSubviews(views: previewImageView,
                    playerView,
                    overlayView,
                    flashBtn,
                    rotateView,
                    captureBtn,
                    captureTimeLabel,
                    closeBtn)
        
        playerView.setup(for: shot)
        playerView.fillSuperview()
        playerView.isHidden = true
        
        previewImageView.fillSuperview()
        previewImageView.backgroundColor = .clear
        previewImageView.image = nil
        
        setupOverlay(shot)
        setupCaptureLabel()
        setupCaptureBtn()
        setupFlash()
        
        closeBtn.addTarget(self,
                           action: #selector(userTappedClose),
                           for: .touchUpInside)
        
        closeBtn.setMargins(.top(value: 44),
                            .left(value: 12))
    }
    
    func  updatePreview(layer: AVCaptureVideoPreviewLayer) {
        previewImageView.layer.addSublayer(layer)
    }
    
    @objc private func userTappedClose() {
        onCloseTapped?()
    }
    
    // MARK: - Player
    func setupPlayer(shot: ShotObject) {
        playerView?.makeVideoPlayable(for: shot.getVideoUrl())
    }

    // MARK: - Overlay
    
    private func setupOverlay(_ shot: ShotObject) {
        overlayView.setMargins(.top(value: 0),
                               .right(value: 0),
                               .bottom(value: 0))
        overlayView.setWidth(112)
        overlayView.setupWith(shot: shot)
        overlayView.isHidden = true
        overlayView.onUserTappedSaveAction = userTappedClose
    }
    
    // MARK: Capture Label
    private func setupCaptureLabel() {
        captureTimeLabel.setMargins(.top(value: 44))
        captureTimeLabel.anchorCenterXToSuperview()
        captureTimeLabel.textAlignment = .center
        captureTimeLabel.textColor = UIColor.white
        captureTimeLabel.setHeight(22)
        captureTimeLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        captureTimeLabel.setCornerRadius(radius: 4)
        captureTimeLabel.text = "00:00:00  "
        captureTimeLabel.font = UIFont.systemFont(ofSize: 14,
                                                  weight: .medium)
    }
    
    // MARK: - Capture Button
    var onCaptureStartAction: (()->Void)?
    var onCaptureStopAction:  (()->Void)?
    
    private func setupCaptureBtn() {
        captureBtn.backgroundColor = UIColor.white
        
        captureBtn.setMargins(.bottom(value: 64))
        captureBtn.anchorCenterXToSuperview()
        captureBtn.setHeight(48)
        captureBtn.setWidth(48)
        captureBtn.setCornerRadius(radius: 24)
        captureBtn.addBorder(width: 2,
                             color: UIColor.tertiarySystemBackground)
        captureBtn.backgroundColor = .red
        captureBtn.addTarget(self,
                             action: #selector(userTappedCaptureBtn),
                             for: UIControl.Event.touchUpInside)
    }
    
    @objc private func userTappedCaptureBtn() {
        if timer?.isValid ?? false {
            onCaptureStopAction?()
            captureStopped()
            
            overlayView.isHidden = false
            captureBtn.isHidden = true
            flashBtn.isHidden = true
        } else {
            captureStarted()
        }
    }
    
    // MARK: - Flash
    private var flashStatus: FlashStatus = .off {
        didSet {
            flashBtn.layer.borderWidth = 2
            flashBtn.layer.borderColor = flashStatus == .off ?
                UIColor.black.cgColor :
                UIColor.white.cgColor
        }
    }
    
    var onUserTappedFlash: (()->Void)?
    
    private func setupFlash() {
        flashBtn.backgroundColor = .red
        
        flashBtn.setMarginTo(view: captureBtn,
                             with: .right(value: 84))
        flashBtn.setMargins(.bottom(value: 72))
        flashBtn.setWidth(32)
        flashBtn.setHeight(32)
        flashBtn.setCornerRadius(radius: 16)
        flashBtn.setTitle("F", for: .normal)
        flashBtn.setTitleColor(.white,
                              for: .normal)
        flashBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        flashBtn.titleLabel?.textAlignment = .center
        flashBtn.addBorder(width: 1,
                             color: UIColor.black)
        flashBtn.backgroundColor = .black
        
        flashBtn.addTarget(self,
                           action: #selector(toggleFlash),
                           for: .touchUpInside)
    }
    
    @objc private func toggleFlash() {
        flashStatus = flashStatus == .off ? .on : .off
        
        onUserTappedFlash?()
    }
    
    // MARK: - Timer
    private var timer: Timer?
    private var seconds = 0
    
    private func captureStarted() {
        updateTimeLabel(TimeInterval(0))
        setupTimer()
        
        onCaptureStartAction?()
        
        captureTimeLabel.backgroundColor = UIColor.red.withAlphaComponent(0.7)
    }
    
    private func captureStopped() {
        timer?.invalidate()
        timer = nil
        captureTimeLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        onCaptureStopAction?()
    }
    
    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(1),
                                     repeats: true,
                                     block: { [weak self] timer in
            
            if timer.isValid {
                self?.seconds += 1
                
                Queue.main.execute {
                    self?.updateTimeLabel(TimeInterval(self?.seconds ?? 0))
                }
            }
        })
    }
    
    private func updateTimeLabel(_ time: TimeInterval) {
        let hours   = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        
        let currentTimeText = String(format:"%02i:%02i:%02i",
                                     hours,
                                     minutes,
                                     seconds)
        
        captureTimeLabel.text = "\(currentTimeText)  "
    }
}
