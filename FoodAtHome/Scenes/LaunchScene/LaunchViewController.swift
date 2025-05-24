//
//  LaunchViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 20.05.2025.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        applySavedTheme()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.showMainApp()
        }
    }

    private func applySavedTheme() {
        let index = UserDefaults.standard.integer(forKey: "selectedSwitchIndex")
        switch index {
        case 1:
            overrideUserInterfaceStyle = .dark
        case 2:
            overrideUserInterfaceStyle = .light
        default:
            overrideUserInterfaceStyle = .unspecified
        }
    }

    private func showMainApp() {
        guard let window = UIApplication.shared.delegate?.window ?? nil else {
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") // Укажи свой ID

        window.rootViewController = mainVC
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}
