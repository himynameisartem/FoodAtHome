//
//  ChoiseFoodRouter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2024.
//

import UIKit

@objc protocol ChoiseFoodRoutingLogic {
    func routeToAddFood()
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
    
    func navigateToAddFood(source: ChoiseFoodViewController, destination: AddFoodViewController) {
        destination.modalPresentationStyle = .custom
        destination.transitioningDelegate = source
        source.navigationController?.present(destination, animated: true)
    }
    
    func passDataToAddFood(source: ChoiseFoodDataStore, destination: inout AddFoodDataStore) {
        let food = source.addFood
        destination.food = food
    }
}
