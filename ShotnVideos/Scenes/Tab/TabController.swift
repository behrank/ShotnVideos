//
//  TabController.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 23.05.2021.
//

import UIKit

class TabController: UITabBarController {
    
    @available(iOS 13.0, *)
    lazy public var dashboard: UIViewController = {
        
        let tabVc = Scene.dashboard.viewController
        
        let tabBarItem = UITabBarItem(title: AppDefault.Tab.dashboard.title.capitalized,
                                      image: AppDefault.Tab.dashboard.image,
                                      selectedImage: AppDefault.Tab.dashboard.selectedImage)
        
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: AppDefault.Tab.dashboard.font],
                                          for: .normal)
        
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: AppDefault.Tab.dashboard.font,
                                           NSAttributedString.Key.foregroundColor: AppDefault.Tab.dashboard.selectedTextColor],
                                          for: .selected)
        
        tabVc.tabBarItem = tabBarItem

        return tabVc
    }()
    
    @available(iOS 13.0, *)
    lazy public var chart: UIViewController = {
        
        let tabVc = Scene.chart.viewController
        
        let tabBarItem = UITabBarItem(title: AppDefault.Tab.chart.title.capitalized,
                                      image: AppDefault.Tab.chart.image,
                                      selectedImage: AppDefault.Tab.chart.selectedImage)
        
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: AppDefault.Tab.chart.font,
                                           NSAttributedString.Key.foregroundColor: AppDefault.Tab.chart.selectedTextColor],
                                          for: .selected)
        
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: AppDefault.Tab.chart.font,
                                           NSAttributedString.Key.foregroundColor: AppDefault.Tab.chart.selectedTextColor],
                                          for: .selected)
        
        tabVc.tabBarItem = tabBarItem
        
        return tabVc
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        view.backgroundColor = .systemBackground
        tabBar.backgroundColor = .systemBackground
        tabBar.barTintColor = .systemBackground
        tabBar.layer.borderWidth = 0
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.clipsToBounds = true
        
        if #available(iOS 13.0, *) {
            viewControllers = [dashboard, chart]
        } else {
            // Fallback on earlier versions
        }
    }
}

extension TabController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        debugPrint("Selected \(viewController.title!)")
    }
}
