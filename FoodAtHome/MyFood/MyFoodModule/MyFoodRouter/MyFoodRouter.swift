//
//  MyFoodRouter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 04.07.2023.
//

import UIKit

class MyFoodRouter {
    weak var viewController: MyFoodViewController!
    
    init(viewController: MyFoodViewController!) {
        self.viewController = viewController
    }
}

extension MyFoodRouter: MyFoodRouterProtocol {
    
    func openCategoryFoodViewController(at indexPath: IndexPath, food: [FoodRealm]) {
        let categoryFoodViewController = CategoryListViewController()
        categoryFoodViewController.foodCategoryArray = CategoryFoodManager.shared.appendFoodOnType(at: indexPath, from: food)
        viewController.navigationController?.pushViewController(categoryFoodViewController, animated: true)
    }
}
