//
//  AppDelegate.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 23.05.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    public var appLauncher: AppLauncher?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        appLauncher = AppLauncher(server: .test,
                                  rootScene: .tab)
        
        appLauncher?.startAppWithRootView()
        return true
    }
}
