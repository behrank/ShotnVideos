//
//  CameraController.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import UIKit
import MobileCoreServices

class CameraController: BaseController {
    
    private var currentShot: ShotObject?
    
    init(shot: ShotObject) {
        super.init(nibName: nil,
                   bundle: nil)
        currentShot = shot
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupCam()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraModule?.setupLivePreview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        cameraModule?.startCamera()
    }
    
    private var cameraView: CameraUIView?
    private var cameraModule: CameraModule?
    
    private func setupCam() {
        
        guard let currentShot = currentShot else {
            return
        }
        
        cameraView = CameraUIView(shot: currentShot)
        cameraModule = CameraModule(shot: currentShot)
        
        guard let cameraView = cameraView,
              let cameraModule = cameraModule else {
            return
        }
        
        view.addSubviews(views: cameraView)
        
        cameraView.fillSuperview()
        cameraView.onCloseTapped = dismissCurrentScene
        cameraView.onCaptureStartAction = cameraModule.startCapture
        cameraView.onCaptureStopAction = cameraModule.stopCapture
        cameraView.onUserTappedFlash = cameraModule.flashStatusChanged
        cameraModule.onVideoSavedAction = cameraView.setupPlayer
        cameraModule.onUpdatePreview = cameraView.updatePreview(layer:)
    }
    
    override func dismissCurrentScene() {
        super.dismissCurrentScene()
    }
}
