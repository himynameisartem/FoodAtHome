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
        let categoryFoodConfiguration: CategoryFoodConfiguratorProtocol = CategoryFoodConfigurator()
        categoryFoodConfiguration.configure(with: categoryFoodViewController, CategoryFoodManager.shared.appendFoodOnType(at: indexPath, from: food) , categoryName: foodCatigoriesList[indexPath.row])
        viewController.navigationController?.pushViewController(categoryFoodViewController, animated: true)
        categoryFoodViewController.navigationController?.navigationBar.isHidden = true
    }
    
    func openFoodListViewController() {
        let listVC = FoodListViewController()
        listVC.modalPresentationStyle = .fullScreen
        listVC.foodList = vegitables
        viewController.navigationController?.pushViewController(listVC, animated: true)
    }
}
