//
//  ShotCell.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import UIKit
import AVFoundation

class ShotCell: UICollectionViewCell {
    
    lazy private var pointLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor.secondaryLabel
        return label
    }()
    
    lazy private var pointAmountLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor.label
        return label
    }()
    
    lazy private var posXLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor.secondaryLabel
        return label
    }()
    
    lazy private var posXAmountLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor.label
        return label
    }()
    
    lazy private var posYLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor.secondaryLabel
        return label
    }()
    
    lazy private var posYAmountLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor.label
        return label
    }()
    
    lazy private var thumbnailImage: UIImageView = {
        var imgView = UIImageView(frame: .zero)
        imgView.setCornerRadius(radius: 4)
        return imgView
    }()
    
    lazy private var playButton: UIButton = {
        var btn = UIButton(frame: .zero)
        btn.setTitle("Play",
                     for: .normal)
        
        btn.titleLabel?.textColor = .white
        btn.backgroundColor = .blue.withAlphaComponent(0.8)
        btn.setCornerRadius(radius: 8)
        return btn
    }()
    
    override func prepareForReuse() {
        thumbnailImage.image = nil
        thumbnailImage.removeFromSuperview()
    }
    
    var onPlayButtonTapped: ((ShotObject)->Void)?
    
    private var currentShot: ShotObject?
    
    func setupWith(shot: ShotObject) {
        
        currentShot = shot
        
        contentView.addSubviews(views: pointLabel,
                                pointAmountLabel,
                                posXLabel,
                                posXAmountLabel,
                                posYLabel,
                                posYAmountLabel,
                                playButton)
        
        contentView.backgroundColor = .systemBackground
        contentView.setCornerRadius(radius: 8)
        
        pointLabel.setMargins(.top(value: 16),
                              .left(value: 16))
        
        pointAmountLabel.setMargins(.top(value: 16))
        pointAmountLabel.setMarginTo(view: pointLabel,
                                     with: .right(value: 8))
        
        posXLabel.setMarginTo(view: pointLabel,
                              with: .bottom(value: 8))
        
        posXLabel.setMargins(.left(value: 16))
        
        posXAmountLabel.setMarginTo(view: posXLabel,
                                    with: .right(value: 8))
        posXAmountLabel.setMarginTo(view: pointAmountLabel,
                                    with: .bottom(value: 8))
        
        posYLabel.setMarginTo(view: posXLabel,
                              with: .bottom(value: 8))
        posYLabel.setMargins( .left(value: 16))
        
        posYAmountLabel.setMarginTo(view: posXAmountLabel,
                                    with: .bottom(value: 8))
        posYAmountLabel.setMarginTo(view: posYLabel,
                                    with: .right(value: 8))
        
        playButton.setMargins(.bottom(value: 16),
                              .right(value: 16),
                              .left(value: 16))
        playButton.setHeight(40)
        playButton.addTarget(self,
                             action: #selector(userTappedPlayBtn),
                             for: .touchUpInside)
        
        pointLabel.text = "Point:"
        pointAmountLabel.text = "\(shot.point)"
        
        posXLabel.text = "PosX:"
        posXAmountLabel.text = "\(shot.shotPosX)"
        
        posYLabel.text = "PosY:"
        posYAmountLabel.text = "\(shot.shotPosY)"
        
        if shot.hasVideo {
            contentView.addSubviews(views: thumbnailImage)
            
            thumbnailImage.setMargins(.top(value: 16),
                                      .right(value: 16))
            thumbnailImage.setWidth(120)
            thumbnailImage.setHeight(90)
            
            Queue.main.execute { [weak self] in
                self?.thumbnailImage.image = self?.generateThumbnail(url: shot.getVideoUrl())
                
            }
        }
    }
    
    @objc private func userTappedPlayBtn() {
        
        guard let currentShot = currentShot else {
            return
        }
        
        onPlayButtonTapped?(currentShot)
    }
    
    func generateThumbnail(url: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: url)
            
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            let cgImage = try imageGenerator.copyCGImage(at: .zero,
                                                         actualTime: nil)

            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)

            return nil
        }
    }
}
