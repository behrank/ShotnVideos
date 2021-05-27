//
//  Scenes.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 24.05.2021.
//

import UIKit

enum SegueType {
    case show, modal, replace
}

enum Scene {
    case none
    case tab
    
    case dashboard
    case chart
    
    case shots(UserObject)
    case camera(ShotObject)
    
    var viewController: UIViewController {
        switch self {
        
        case .none              : return BaseNavigationController(rootViewController: UIViewController())
        case .tab               : return TabController()
            
        //Tabs
        case .dashboard         : return BaseNavigationController(rootViewController: DashboardController())
        case .chart             : return BaseNavigationController(rootViewController: ChartController())
            
        case .shots(let user)   : return ShotsController(user: user)
        case .camera(let shot)  : return CameraController(shot: shot)
        }
    }
}
