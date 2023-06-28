//
//  AppDelegate.swift
//  OnTheMap
//
//  Created by João Ponte on 06/06/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UITabBar.appearance().barTintColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0) // Light Gray
        UITabBar.appearance().tintColor = UIColor(red: 0.13, green: 0.59, blue: 0.95, alpha: 1.0) // Blue
        UITabBar.appearance().unselectedItemTintColor = UIColor(red: 0.46, green: 0.46, blue: 0.46, alpha: 1.0) // Gray
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running,
        // this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}
