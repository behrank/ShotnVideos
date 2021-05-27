//
//  UIApplication.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import UIKit

extension AppDelegate {
    
    class var currentApp: AppLauncher? {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        guard let app = delegate.appLauncher else  { return nil }
        return app
    }
}
