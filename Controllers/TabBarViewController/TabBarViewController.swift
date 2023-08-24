//
//  TabBarViewController.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 25.07.2022.
//

import Foundation
import UIKit


class TabBarViewController: UITabBarController {
    
    private var isBottom: Bool {
        if #available(iOS 13.0, *), UIApplication.shared.windows[0].safeAreaInsets.bottom > 0 {
            return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        generateTabBar()
        setTabBarAppearance()
    }
}

extension TabBarViewController {
    
    private func setupUI() {
         if !isBottom {
             additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0)
         }
     }
    
    private func generateTabBar() {
        
        let navVC = UINavigationController()
        navVC.viewControllers = [MyFoodViewController()]
        
        viewControllers = [
                           generateViewController(viewController: ListVC(),
                                                  title: "Покупки",
                                                  image: UIImage(systemName: "list.bullet.rectangle.portrait.fill")),
                           generateViewController(viewController: navVC,
                                                  title: "Еда Дома",
                                                  image: UIImage(systemName: "house.fill")),
                           generateViewController(viewController: ShareVC(),
                                                  title: "Поделиться",
                                                  image: UIImage(systemName: "square.and.arrow.up"))
        ]
    }
    
    private func generateViewController(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        
        return viewController
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
        tabBar.itemPositioning = .centered
        
        roundLayer.shadowColor = UIColor.gray.cgColor
        roundLayer.shadowRadius = 8
        roundLayer.shadowOpacity = 0.5
        roundLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        
        roundLayer.fillColor = UIColor.mainTabBarColor.cgColor
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemLight
        
    }
    
}
