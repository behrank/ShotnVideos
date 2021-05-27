//
//  AppLauncher.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 24.05.2021.
//

import UIKit
import SystemConfiguration
import RealmSwift

class AppLauncher {
    
    private var window: UIWindow?
    private var currentServer : ServerType
    private var defaultScene: Scene = .none

    init(server: ServerType, rootScene: Scene) {
        currentServer = server
        defaultScene = rootScene
    }
    
    func startAppWithRootView() {
        window = UIApplication.shared.windows.first
        
        if window == nil {
            if #available(iOS 13.0, *), let currentWindow = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                window = UIWindow(windowScene: currentWindow)
            } else {
                // Fallback on earlier versions
                window = UIWindow(frame: UIScreen.main.bounds)
            }
        }
        
        window?.rootViewController = defaultScene.viewController
        window?.makeKeyAndVisible()
        
        makeRealmMigrations()
    }
    
    func getCurrentServerUrl() -> String {
        return currentServer.serverUrl()
    }
    
    func isConnectedToNetwork() -> Bool {
            
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
     
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
     
            var flags = SCNetworkReachabilityFlags()
        
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
                return false
            }
        
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            return (isReachable && !needsConnection)
     
        }

    private func makeRealmMigrations() {

        let config = Realm.Configuration(
            schemaVersion: 1,

            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {

                }
                debugPrint("Database migrated")
        })

        Realm.Configuration.defaultConfiguration = config

        let _ = try! Realm()
    }
}
