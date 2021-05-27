//
//  CircleButton.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 27.05.2021.
//

import UIKit

class CircleButton: UIButton {
    
    init(width: CGFloat, height: CGFloat, imageName: String) {
        super.init(frame: .zero)
        
        setImage(UIImage(named: imageName),
                 for: .normal)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.7)

        setWidth(width)
        setHeight(height)
        setCornerRadius(radius: height/2)

        imageEdgeInsets = UIEdgeInsets(top: 12,
                                                left: 12,
                                                bottom: 12,
                                                right: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
