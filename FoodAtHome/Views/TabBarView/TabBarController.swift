//
//  TabBarController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit
import LocalAuthentication


class TabBarController: UITabBarController {
    
    @IBOutlet weak var tabBarView: UITabBar!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if view.safeAreaInsets.bottom == 0.0 {
            tabBar.frame.origin.y -= 20
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setTabBarAppearance()
    }
    
    private func setupTabBar() {
        selectedViewController = viewControllers?[1]        
    }
    
    private func setTabBarAppearance() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(
            roundedRect: CGRect(x: positionOnX, y: tabBar.bounds.minY - positionOnY, width: width, height: height),
            cornerRadius: height / 2
        )

        roundLayer.path = bezierPath.cgPath
        
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        tabBar.itemWidth = width / 3
        tabBar.itemPositioning = .fill
        
        roundLayer.shadowColor = UIColor.gray.cgColor
        roundLayer.shadowRadius = 8
        roundLayer.shadowOpacity = 0.5
        roundLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        
        roundLayer.fillColor = UIColor.mainTabBarColor.cgColor
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemLight
            
    }
}
