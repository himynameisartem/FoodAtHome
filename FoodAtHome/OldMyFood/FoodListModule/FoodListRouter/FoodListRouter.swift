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
        
        if viewController.navigationController?.viewControllers.first(where: { $0 is OldMyFoodViewController }) is OldMyFoodViewController {
            addAndChangeFoodView.showOptionsMenu(for: viewController, choiseType: .foodList)
        }
        
        if viewController.navigationController?.viewControllers.first(where: { $0 is OldShoppingListViewController }) is OldShoppingListViewController {
            addAndChangeFoodView.showOptionsMenu(for: viewController, choiseType: .shoppingList)
        }

    }
    
    func backToRootViewController() {
        
        if let myFoodViewController = viewController.navigationController?.viewControllers.first(where: { $0 is OldMyFoodViewController }) as? OldMyFoodViewController {
            myFoodViewController.presenter.viewDidLoad()
            myFoodViewController.reloadData()
        }
        
        if let shoppingListViewController = viewController.navigationController?.viewControllers.first(where: { $0 is OldShoppingListViewController }) as? OldShoppingListViewController {
            shoppingListViewController.presenter.viewDidLoad()
        }
        
        viewController.navigationController?.popToRootViewController(animated: true)
    }
}
