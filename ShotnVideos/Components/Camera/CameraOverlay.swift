//
//  CameraOverlay.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 27.05.2021.
//

import UIKit

enum VideoPlayStatus {
    case playing, stopped
}

class CameraOverlay: UIView {

    lazy private var pointLabel: OverlayLabel   = { return OverlayLabel() }()
    lazy private var segmentLabel: OverlayLabel = { return OverlayLabel() }()
    lazy private var inOutLabel: OverlayLabel   = { return OverlayLabel() }()
    lazy private var shotXLabel: OverlayLabel   = { return OverlayLabel() }()
    lazy private var shotYLabel: OverlayLabel   = { return OverlayLabel() }()
    lazy private var reTakeBtn: UIButton        = { return UIButton(frame: .zero) }()
    lazy private var saveBtn: UIButton          = { return UIButton(frame: .zero) }()

    
    private var currentShot: ShotObject?
    
    var onUserTappedSaveAction: (()->Void)?
    
    func setupWith(shot: ShotObject) {
        currentShot = shot
        
        guard let currentShot = currentShot else {
            return
        }
        
        pointLabel.text = "\(currentShot.point)"
        segmentLabel.text = "\(currentShot.segment)"
        inOutLabel.text = currentShot.inOut ? "In" : "Out"
        shotXLabel.text = "\(currentShot.shotPosX)"
        shotYLabel.text = "\(currentShot.shotPosY)"
        
        addSubviews(views: pointLabel,
                    segmentLabel,
                    inOutLabel,
                    shotXLabel,
                    shotYLabel,
                    saveBtn)
        
        pointLabel.setMargins(.top(value: 120),
                              .right(value: 24))
        pointLabel.setTitle("point")
        
        segmentLabel.setMargins(.right(value: 24))
        segmentLabel.setMarginTo(view: pointLabel,
                                 with: .bottom(value: 12))
        segmentLabel.setTitle("segment")
        
        inOutLabel.setMargins(.right(value: 24))
        inOutLabel.setMarginTo(view: segmentLabel,
                                 with: .bottom(value: 12))
        inOutLabel.setTitle("In/Out")
        
        shotXLabel.setMargins(.right(value: 24))
        shotXLabel.setMarginTo(view: inOutLabel,
                                 with: .bottom(value: 12))
        shotXLabel.setTitle("x position")
        
        shotYLabel.setMargins(.right(value: 24))
        shotYLabel.setMarginTo(view: shotXLabel,
                                 with: .bottom(value: 12))
        shotYLabel.setTitle("y position")
        
        saveBtn.setMargins(.top(value: 44),
                           .right(value: 16))
        saveBtn.setTitle("SAVE",
                         for: .normal)
        saveBtn.setTitleColor(.white,
                              for: .normal)
        saveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        saveBtn.titleLabel?.textAlignment = .center
        saveBtn.setCornerRadius(radius: 4)
        saveBtn.backgroundColor = .red
        saveBtn.setWidth(96)
        
        saveBtn.addTarget(self,
                          action: #selector(saveButtonTapped),
                          for: .touchUpInside)
    }
    
    @objc private func saveButtonTapped() {
        guard let currentShot = currentShot else {
            return
        }
        
        saveBtn.setTitle("SAVING",
                         for: .normal)
        
        currentShot.saveVideo()
        
        Queue.main.executeAfter(delay: .oneSecond) {
            self.onUserTappedSaveAction?()
        }
    }
}
