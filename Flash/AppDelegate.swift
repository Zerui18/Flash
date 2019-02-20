//
//  AppDelegate.swift
//  Flash
//
//  Created by Zerui Chen on 16/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import UIKit
import SMV

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow? = UIWindow()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        let decksVC = DecksViewController()
        let rootVC = UINavigationController(rootViewController: decksVC)
        rootVC.navigationBar.prefersLargeTitles = true
        rootVC.navigationBar.largeTitleTextAttributes = [
            .font               :   UIFont.systemFont(ofSize: 52, weight: .medium),
            .foregroundColor    :   UIColor.white
        ]
        rootVC.navigationBar.isTranslucent = false
        rootVC.navigationBar.barTintColor = UIColor(named: "PrimaryBlue")
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        return true
    }
    
    private func createMockData()
    {
        
    }

    func applicationWillResignActive(_ application: UIApplication)
    {
//        try! SMVEngine.shared.saveToDisk() disabled for debugging purposes
    }

}

