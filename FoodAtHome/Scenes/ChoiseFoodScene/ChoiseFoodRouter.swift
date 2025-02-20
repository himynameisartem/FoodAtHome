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
            passDataToAddFood(source: sourceDS, destenation: &destinationDS)
        }
        navigateToAddFood(source: viewController!, destenation: destinationVC)
    }
    
    func navigateToAddFood(source: ChoiseFoodViewController, destenation: AddFoodViewController) {
        destenation.modalPresentationStyle = .custom
        destenation.transitioningDelegate = source
        source.present(destenation, animated: true)
    }
    
    func passDataToAddFood(source: ChoiseFoodDataStore, destenation: inout AddFoodDataStore) {
        let food = source.addFood
        destenation.food = food
    }
}
