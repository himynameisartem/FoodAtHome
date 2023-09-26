//
//  FoodListRouter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 02.08.2023.
//

import Foundation

class FoodListRouter {
    
    weak var viewController: FoodListViewController!
    var addAndChangeFoodView = AddAndChangeFoodView()
    
    init(viewController: FoodListViewController!) {
        self.viewController = viewController
    }
}
    
extension FoodListRouter: FoodListRouterProtocol {
    
    func openAddFoodView(_ food: FoodRealm) {
        DispatchQueue.main.async {
            self.addAndChangeFoodView.configure(food: food)
        }

        viewController.delegate = addAndChangeFoodView
        
        if viewController.navigationController?.viewControllers.first(where: { $0 is MyFoodViewController }) is MyFoodViewController {
            addAndChangeFoodView.showOptionsMenu(for: viewController, choiseType: .foodList)
        }
        
        if viewController.navigationController?.viewControllers.first(where: { $0 is ShoppingListViewController }) is ShoppingListViewController {
            addAndChangeFoodView.showOptionsMenu(for: viewController, choiseType: .shoppingList)
        }

    }
    
    func backToRootViewController() {
        
        if let myFoodViewController = viewController.navigationController?.viewControllers.first(where: { $0 is MyFoodViewController }) as? MyFoodViewController {
            myFoodViewController.presenter.viewDidLoad()
            myFoodViewController.reloadData()
        }
        
        if let shoppingListViewController = viewController.navigationController?.viewControllers.first(where: { $0 is ShoppingListViewController }) as? ShoppingListViewController {
            shoppingListViewController.presenter.viewDidLoad()
        }
        
        viewController.navigationController?.popToRootViewController(animated: true)
    }
}
