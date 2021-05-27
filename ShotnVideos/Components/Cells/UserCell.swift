//
//  UserCell.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    lazy private var titleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.secondaryLabel
        return label
    }()
    
    lazy private var fullnameLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.label
        return label
    }()
    
    lazy private var shotCountLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textColor = UIColor.tertiaryLabel
        return label
    }()
    
    func setupWith(user: UserObject) {
        contentView.backgroundColor = .systemBackground
        contentView.addSubviews(views: titleLabel,
                                fullnameLabel,
                                shotCountLabel)
        
        titleLabel.setMargins(.left(value: 16),
                              .top(value: 16),
                              .right(value: 16))
        
        fullnameLabel.setMargins(.left(value: 16),
                                 .right(value: 16))
        
        fullnameLabel.setMarginTo(view: titleLabel,
                                  with: .bottom(value: 4))
        
        shotCountLabel.setMargins(.left(value: 16),
                                  .right(value: 16))
        
        shotCountLabel.setMarginTo(view: fullnameLabel,
                                   with: .bottom(value: 4))
        
        titleLabel.text = "User"
        fullnameLabel.text = user.getFullName()
        shotCountLabel.text = "Shots: \(user.shots.count)"
    }
}
