//
//  AddShoppingListRouter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.02.2025.
//

import UIKit

protocol AddShoppingListRoutingLogic {
    
}

protocol AddShoppingListDataPassing {
    var dataStore: AddShoppingListDataStore? { get }
}

class AddShoppingListRouter: NSObject, AddShoppingListRoutingLogic, AddShoppingListDataPassing {
    
    weak var viewController: AddShoppingListViewController?
    var dataStore: AddShoppingListDataStore?
    
    // MARK: Routing
    
}
