//
//  MyFoodRouter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 04.07.2023.
//

import UIKit

class OldMyFoodRouter {
    weak var viewController: OldMyFoodViewController!
    
    init(viewController: OldMyFoodViewController!) {
        self.viewController = viewController
    }
}

extension OldMyFoodRouter: OldMyFoodRouterProtocol {
    
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
        listVC.foodList = vegitables.sorted { $0.name.localized() < $1.name.localized() }
        viewController.navigationController?.pushViewController(listVC, animated: true)
    }
}
