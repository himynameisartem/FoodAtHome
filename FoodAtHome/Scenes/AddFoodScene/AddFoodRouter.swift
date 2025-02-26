//
//  AddFoodRouter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 13.01.2025.
//

import UIKit

@objc protocol AddFoodRoutingLogic {
    func navigateToTabBarController(window: UIWindow)
}

protocol AddFoodDataPassing {
    var dataStore: AddFoodDataStore? { get set }
}

class AddFoodRouter: NSObject, AddFoodRoutingLogic, AddFoodDataPassing {
    
    weak var viewController: AddFoodViewController?
    var dataStore: AddFoodDataStore?
        
    func navigateToTabBarController(window: UIWindow) {
        viewController?.dismiss(animated: true) {
            if let tabBarController = window.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 1
                if let nav = tabBarController.viewControllers?[1] as? UINavigationController {
                    nav.tabBarController?.tabBar.isHidden = false
                    nav.popToRootViewController(animated: true)
                }
            }
        }
    }
}
