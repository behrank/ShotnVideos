//
//  Cells.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import Foundation
import UIKit

enum ShotnVideo {
    
    enum Cell {
        
        case userCell, shotCell
        
        var reuseId: String {
            switch self {
            case .userCell: return "userCell"
            case .shotCell: return "shotCell"
            }
        }
        
        var frame: CGSize {
            switch self {
            case .userCell: return CGSize(width: UIScreen.main.bounds.width, height: 84)
            case .shotCell: return CGSize(width: (UIScreen.main.bounds.width - 20), height: 180)
            }
        }
    }
}
