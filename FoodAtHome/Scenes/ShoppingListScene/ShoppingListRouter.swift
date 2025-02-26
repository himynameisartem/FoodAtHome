//
//  ShoppingListRouter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol ShoppingListRoutingLogic {
    func routeToAddFood()
}

protocol ShoppingListDataPassing {
    var dataStore: ShoppingListDataStore? { get }
}

class ShoppingListRouter: NSObject, ShoppingListRoutingLogic, ShoppingListDataPassing {

  weak var viewController: ShoppingListViewController?
  var dataStore: ShoppingListDataStore?
    
  // MARK: Routing
  
    func routeToAddFood() {
        let destinationVC = AddFoodViewController()
        if let sourceDS = dataStore, var destinationDS = destinationVC.router?.dataStore {
            passDataToAddFood(source: sourceDS, destination: &destinationDS)
        }
        navigateToAddFood(source: viewController!, destination: destinationVC)
    }
    
    func navigateToAddFood(source: ShoppingListViewController, destination: AddFoodViewController) {
        destination.transitioningDelegate = source
        destination.modalPresentationStyle = .custom
        source.present(destination, animated: true)
    }
    
    func passDataToAddFood(source: ShoppingListDataStore, destination: inout AddFoodDataStore) {
        destination.food = source.editingFood
    }
}
