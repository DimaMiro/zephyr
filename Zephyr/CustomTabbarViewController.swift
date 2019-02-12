//
//  CustomTabbarViewController.swift
//  Zephyr
//
//  Created by Dima Miro on 10/02/2019.
//  Copyright © 2019 Dima Miro. All rights reserved.
//

import UIKit

class CustomTabbarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tintColor = UIColor.CustomColor.green
        
        let firstVC = OverviewViewController()
        let firstNavigationController = UINavigationController(rootViewController: firstVC)
        firstNavigationController.tabBarItem.title = "Overview"
        firstNavigationController.tabBarItem.image = UIImage(named: "overview-ico")
        
        let secondVC = MapViewController()
        secondVC.tabBarItem.title = "Map"
        secondVC.tabBarItem.image = UIImage(named: "map-ico")
        secondVC.overviewVCInstance = firstVC
        
        viewControllers = [firstNavigationController, secondVC]
        
    }
}
