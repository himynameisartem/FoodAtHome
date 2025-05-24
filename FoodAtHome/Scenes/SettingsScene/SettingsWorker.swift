//
//  SettingsWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

protocol SettingsWorkerProtocol {
    func setTheme(style: UIUserInterfaceStyle)
    func setLanguage(code: String)
    func fetchLanguage(from code: String) -> String
}

class SettingsWorker: SettingsWorkerProtocol {
    
    private let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    
    func setTheme(style: UIUserInterfaceStyle) {
        guard let window = windowScene?.windows.first else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            switch style {
            case .unspecified:
                window.overrideUserInterfaceStyle = .unspecified
            case .light:
                window.overrideUserInterfaceStyle = .light
            case .dark:
                window.overrideUserInterfaceStyle = .dark
            default:
                break
            }
        }
    }
    
    func setLanguage(code: String) {
        LanguageManager.shared.currentLanguage = code
        if let window = windowScene?.windows.first {
            let rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            window.rootViewController = rootVC
            window.makeKeyAndVisible()
        }
    }
    
    func fetchLanguage(from code: String) -> String {
        switch code {
        case "en":
            return "English"
        case "ru":
            return "Русский"
        default:
            return "unknown"
        }
    }
}
