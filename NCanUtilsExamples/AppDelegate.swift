//
//  AppDelegate.swift
//  NCanUtilsExamples
//
//  Created by Nguyen Can on 4/26/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

import UIKit
import NCanUtils

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        LanguageUtility.configureAppLanguage()
        
        CNManager.shared.style.shadowColor = .darkGray
        
        CNManager.shared.style.gradientStartColor = .red
        CNManager.shared.style.gradientEndColor = .purple
        
        CNManager.shared.style.progress.startColor = .white
        CNManager.shared.style.progress.endColor = .green
        CNManager.shared.style.progress.bgStartColor = UIColor(hex: 0x0F1C32).alpha(0.72)
        CNManager.shared.style.progress.bgEndColor = UIColor(hex: 0x05080E)
        
        CNManager.shared.style.button.rippleEffect = true
        CNManager.shared.style.button.rippleColor = .green
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

