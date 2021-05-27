//
//  OverLabel.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 27.05.2021.
//

import UIKit

class OverlayLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
    
        textAlignment = .center
        textColor = UIColor.yellow

        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        font = UIFont.systemFont(ofSize: 18,
                                 weight: .medium)
        
        setHeight(64)
        setWidth(84)
        setCornerRadius(radius: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.font = UIFont.systemFont(ofSize: 10,
                                            weight: .medium)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        addSubviews(views: titleLabel)
        titleLabel.setMargins(.top(value: 6),
                              .left(value: 4), .right(value: 4))
        titleLabel.text = title.uppercased()
        
    }
}
