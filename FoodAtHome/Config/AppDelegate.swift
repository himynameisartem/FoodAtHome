//
//  AppDelegate.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.05.2022.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var localRealm: Realm?
    
    private func initializeRealm() {
        let config = Realm.Configuration(schemaVersion: 2)
        localRealm = try! Realm(configuration: config)
    }
    
    func setLanguage() {
        guard let code = UserDefaults.standard.string(forKey: "selectedLanguageCode") else { return }
        LanguageManager.shared.currentLanguage = code
    }

    func applySavedTheme() {
        let index = UserDefaults.standard.integer(forKey: "selectedSwitchIndex")
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }
        switch index {
        case 0:
            window.overrideUserInterfaceStyle = .unspecified
        case 1:
            window.overrideUserInterfaceStyle = .dark
        case 2:
            window.overrideUserInterfaceStyle = .light
        default:
            window.overrideUserInterfaceStyle = .unspecified
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication .LaunchOptionsKey: Any]?) -> Bool {
        initializeRealm()
        MigrationManager.shared.migrateIfNeeded()
        NotificationManager.shared.requestNotificationPermission()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        applySavedTheme()
        setLanguage()
    }

    func applicationWillTerminate(_ application: UIApplication) {}
}

