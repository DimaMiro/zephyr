//
//  AppDelegate.swift
//  Zephyr
//
//  Created by Dima Miro on 03/02/2019.
//  Copyright © 2019 Dima Miro. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        window?.makeKeyAndVisible()
        
        window?.rootViewController = CustomTabbarViewController()
        return true
    }
}

