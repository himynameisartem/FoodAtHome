//
//  AddFoodRouter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 13.01.2025.
//

import UIKit

@objc protocol AddFoodRoutingLogic {
    
}

protocol AddFoodDataPassing {
    var dataStore: AddFoodDataStore? { get set }
}

class AddFoodRouter: NSObject, AddFoodRoutingLogic, AddFoodDataPassing {
    
    weak var viewController: AddFoodViewController?
    var dataStore: AddFoodDataStore?
    
    // MARK: Routing
    
}
