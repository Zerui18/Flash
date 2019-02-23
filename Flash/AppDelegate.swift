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
        createMockData()
        let decksVC = DecksViewController()
        let rootVC = UINavigationController(rootViewController: decksVC)
        rootVC.navigationBar.prefersLargeTitles = true
        rootVC.navigationBar.largeTitleTextAttributes = [
            .font               :   UIFont.systemFont(ofSize: 48, weight: .medium),
            .foregroundColor    :   UIColor.white
        ]
        rootVC.navigationBar.barStyle = .black
        rootVC.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        rootVC.navigationBar.isTranslucent = false
        rootVC.navigationBar.barTintColor = .pBlue
        rootVC.navigationBar.tintColor = .white
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
        return true
    }
    
    private func createMockData()
    {
        SMVEngine.shared.createSet(named: "Hiragana Set", description: "Complete set of the 56 Hiragana characters, with their Romanji pronounciations.")
        SMVEngine.shared.createSet(named: "Katagana Set", description: "Complete set of the 56 Katagana characters, with their Romanji pronounciations.")
        SMVEngine.shared.createSet(named: "Jisho Verbs", description: "Japanese verbs in their jisho form.")
        let set1 = SMVEngine.shared.sets[0]
        let hiraganas = "あいえおう"
        let romanjis = "aieou"
        zip(hiraganas, romanjis).forEach {
            let (h, r) = $0
            set1.addItem(front: String(h), back: String(r))
        }
        let set3 = SMVEngine.shared.sets[2]
        set3.addItem(front: "食べる", back: "1. to each\n2. to live on (e.g. salary); to live off; to subsist on")
        set3.addItem(front: "楽しむ", back: "1. to enjoy(oneself)")
        set3.addItem(front: "斬る", back: "1. to kill (a human) using a blade (sword, machete, knife, etc.); to slice (off); to lop (off); to cut (off)​")
        set3.addItem(front: "飲む", back: "1. to drink; to gulp; to swallow; to take (medicine)​\n2.to engulf; to overwhelm​")
    }

    func applicationWillResignActive(_ application: UIApplication)
    {
//        try! SMVEngine.shared.saveToDisk() disabled for debugging purposes
    }

}

