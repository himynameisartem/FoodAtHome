//
//  CategoryDetailsRouter.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.07.2024.
//

import UIKit

@objc protocol CategoryDetailsRoutingLogic {
    
}

protocol CategoryDetailsDataPassing {
    var dataStore: CategoryDetailsDataStore? { get }
}

class CategoryDetailsRouter: NSObject, CategoryDetailsRoutingLogic, CategoryDetailsDataPassing {
    
    weak var viewController: CategoryDetailsViewController?
    var dataStore: CategoryDetailsDataStore?
    
    // MARK: Routing
    
}
