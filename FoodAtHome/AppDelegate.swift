//
//  AppDelegate.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.05.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navController = UINavigationController()
        let vc = TabBarViewController()
        vc.selectedIndex = 1
        navController.viewControllers = [vc]
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }

}

