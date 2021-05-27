//
//  CameraModule.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import UIKit
import AVFoundation

class CameraModule: NSObject {
    
    private var session: AVCaptureSession?
    @objc dynamic var videoDeviceInput: AVCaptureDeviceInput!
    private var stillImageOutput: AVCapturePhotoOutput?
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    private var movieOutput = AVCaptureMovieFileOutput()

    private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera,
                                                                                             .builtInDualCamera,
                                                                                             .builtInTrueDepthCamera],
                                                                               mediaType: .video,
                                                                               position: .unspecified)
    
    private var currentShot: ShotObject?
    
    init(shot: ShotObject?) {
        super.init()
        currentShot = shot
        setupModule()
    }
    
    private func setupModule() {
        
        session = AVCaptureSession()
        
        guard let captureSession = session else {
            return
        }
        
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        captureSession.addOutput(movieOutput)
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else {
            debugPrint("Unable to access back camera!")
            
            return
        }
        
        do {
            videoDeviceInput = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            
            guard let stillImageOutput = stillImageOutput else {
                debugPrint("No image output")
                
                return
            }
            
            if captureSession.canAddInput(videoDeviceInput) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(videoDeviceInput)
                captureSession.addOutput(stillImageOutput)
                captureSession.commitConfiguration()
            }
        }
        catch let error  {
            debugPrint("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    // MARK: - Public Funcs
    var onUpdatePreview: ((AVCaptureVideoPreviewLayer)->Void)?
    var onVideoSavedAction: ((ShotObject)->Void)?
    
    func setupLivePreview() {
        
        guard let captureSession = session else {
            debugPrint("videoPreviewLayer is nil")
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer?.videoGravity = .resizeAspect
        videoPreviewLayer?.connection?.videoOrientation = .portrait
        
        onUpdatePreview?(videoPreviewLayer ?? AVCaptureVideoPreviewLayer()) 
    }

    func startCapture() {
        deleteVideo()
        
        guard let currentShot = currentShot else {
            return
        }
        
        movieOutput.startRecording(to: currentShot.getVideoUrl(),
                                   recordingDelegate: self)
    }
    
    func stopCapture() {
        if movieOutput.isRecording {
            movieOutput.stopRecording()
            stopCamera()
        }
    }
    
    func startCamera() {
        Queue.main.execute {
            
            guard let captureSession = self.session else {
                return
            }
            
            captureSession.startRunning()
            
            self.videoPreviewLayer?.frame = UIScreen.main.bounds
            self.videoPreviewLayer?.videoGravity = .resizeAspectFill
        }
    }
    
    func stopCamera() {
        Queue.main.execute {
            
            guard let captureSession = self.session else {
                return
            }
            
            captureSession.stopRunning()
        }
    }
    
    func deleteVideo() {
        
        guard let currentShot = currentShot else {
            return
        }
        
        try? FileManager.default.removeItem(at: currentShot.getVideoUrl())
    }
    
    func flashStatusChanged() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    debugPrint(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            debugPrint(error)
        }
    }
}

extension CameraModule: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput,
                    didFinishRecordingTo outputFileURL: URL,
                    from connections: [AVCaptureConnection],
                    error: Error?) {
        debugPrint(outputFileURL.absoluteString)
        
        guard let currentShot = currentShot else {
            return
        }
        
        onVideoSavedAction?(currentShot)
    }
}
