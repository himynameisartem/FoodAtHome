//
//  ChoiseFoodRouter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2024.
//

import UIKit

@objc protocol ChoiseFoodRoutingLogic {
    func routeToAddFood()
    func routeToAddShoppingList()
}

protocol ChoiseFoodDataPassing {
    var dataStore: ChoiseFoodDataStore? { get }
}

class ChoiseFoodRouter: NSObject, ChoiseFoodRoutingLogic, ChoiseFoodDataPassing {
    
    weak var viewController: ChoiseFoodViewController?
    var dataStore: ChoiseFoodDataStore?
    
    func routeToAddFood() {
        let destinationVC = AddFoodViewController()
        if let sourceDS = dataStore, var destinationDS = destinationVC.router?.dataStore {
            passDataToAddFood(source: sourceDS, destination: &destinationDS)
        }
        navigateToAddFood(source: viewController!, destination: destinationVC)
    }
    
    func routeToAddShoppingList() {
        let destinationVC = AddShoppingListViewController()
        if let sourceDS = dataStore, var destinationDS = destinationVC.router?.dataStore {
            passDataToShoppingList(source: sourceDS, destination: &destinationDS)
        }
        navigateToAddShoppingList(source: viewController!, destination: destinationVC)
    }
    
    func navigateToAddFood(source: ChoiseFoodViewController, destination: AddFoodViewController) {
        destination.modalPresentationStyle = .custom
        destination.transitioningDelegate = source
        source.navigationController?.present(destination, animated: true)
    }
    
    func navigateToAddShoppingList(source: ChoiseFoodViewController, destination: AddShoppingListViewController) {
        destination.modalPresentationStyle = .custom
        destination.transitioningDelegate = source
        source.navigationController?.present(destination, animated: true)
    }
    
    func passDataToAddFood(source: ChoiseFoodDataStore, destination: inout AddFoodDataStore) {
        let food = source.addFood
        destination.food = food
    }
    
    func passDataToShoppingList(source: ChoiseFoodDataStore, destination: inout AddShoppingListDataStore) {
        let food = source.addFood
        destination.food = food
    }
}
