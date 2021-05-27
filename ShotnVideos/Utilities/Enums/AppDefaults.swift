//
//  AppDefaults.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 23.05.2021.
//

import UIKit

enum AppDefault {
    
    enum Tab {
        case dashboard, chart
        
        var font: UIFont {
            return UIFont.boldSystemFont(ofSize: 12)
        }
        
        var title: String {
            switch self {
            case .chart:        return "chart"
            case .dashboard:    return "dashboard"
            }
        }
        
        var selectedTextColor: UIColor {
            return UIColor.label
        }
        
        var image: UIImage? {
            switch self {
            case .chart:        return UIImage(named: "chart")
            case .dashboard:    return UIImage(named: "dashboard")
            }
        }
        
        var selectedImage: UIImage? {
            switch self {
            case .chart:        return UIImage(named: "chart_selected")
            case .dashboard:    return UIImage(named: "dashboard_selected")
            }
        }
    }
}

