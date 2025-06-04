//
//  LaunchViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 20.05.2025.
//

import UIKit

class LaunchViewController: UIViewController {
    
    private var nameLogo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Inter-Light", size: 30)
        label.textColor = .label
        label.alpha = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applySavedTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureUI()
        setupConstraints()
        loadingMainApp()
    }
    
    @IBOutlet var launchLogoCollection: [UIImageView]!
    
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
    
    private func loadingMainApp() {
        
        logoAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.showMainApp()
        }
    }
    
    private func logoAnimation() {
        for (index, imageView) in launchLogoCollection.enumerated() {
            if imageView.alpha == 0 {
                UIView.animate(withDuration: 1.0,
                               delay: Double(index) * 0.1,
                               options: [],
                               animations: {
                    imageView.alpha = 1
                })
            }
        }
        UIView.animate(withDuration: 1, delay: 0.8) {
            self.nameLogo.alpha = 1
        }
    }
    
    private func configureUI() {
        view.addSubview(nameLogo)
        nameLogo.text = "FOOD AT HOME".localized()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: view.frame.height / 4)
        ])
    }
    
    private func showMainApp() {
        guard let window = UIApplication.shared.delegate?.window ?? nil else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        
        window.rootViewController = mainVC
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
    }
}
