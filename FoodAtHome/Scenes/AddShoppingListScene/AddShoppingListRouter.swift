//
//  AddShoppingListRouter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.02.2025.
//

import UIKit

protocol AddShoppingListRoutingLogic {
    func navigateToTabBarController(window: UIWindow)
}

protocol AddShoppingListDataPassing {
    var dataStore: AddShoppingListDataStore? { get set }
}

class AddShoppingListRouter: NSObject, AddShoppingListRoutingLogic, AddShoppingListDataPassing {
    
    weak var viewController: AddShoppingListViewController?
    var dataStore: AddShoppingListDataStore?
    
    // MARK: Routing
    func navigateToTabBarController(window: UIWindow) {
        viewController?.dismiss(animated: true) {
            if let tabBarController = window.rootViewController as? UITabBarController {
                tabBarController.selectedIndex = 1
                if let nav = tabBarController.viewControllers?[0] as? UINavigationController {
                    nav.tabBarController?.tabBar.isHidden = false
                    nav.popToRootViewController(animated: true)
                }
            }
        }
    }
}
