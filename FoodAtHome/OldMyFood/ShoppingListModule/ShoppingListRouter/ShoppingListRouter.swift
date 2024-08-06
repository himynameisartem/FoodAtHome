//
//  ShoppingListRouter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 06.09.2023.
//

import Foundation

class ShoppingListRouter {
    
    weak var viewController: ShoppingListViewController!
    
    init(viewController: ShoppingListViewController = ShoppingListViewController()) {
        self.viewController = viewController
    }
    
}

extension ShoppingListRouter: ShoppingListRouterProtocol {
    func openFoodListViewController() {
        let listVC = FoodListViewController()
        listVC.modalPresentationStyle = .fullScreen
        listVC.foodList = vegitables.sorted { $0.name.localized() < $1.name.localized() }
        viewController.navigationController?.pushViewController(listVC, animated: true)
    }
    
    
}
