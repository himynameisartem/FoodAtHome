//
//  SettingsWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

protocol SettingsWorkerProtocol {
    
}

class SettingsWorker: SettingsWorkerProtocol {
    
    private func darkTheme() {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            return
        }
        guard let window = windowScene.windows.first else {
            return
        }
        window.overrideUserInterfaceStyle = .dark
    }
}
