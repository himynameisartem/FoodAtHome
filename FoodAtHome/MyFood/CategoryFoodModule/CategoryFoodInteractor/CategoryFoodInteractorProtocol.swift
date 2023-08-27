//
//  CategoryFoodInteractorProtocol.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2023.
//

import Foundation

protocol CategoryFoodInteractorProtocol: AnyObject {
    func provideCategoryFood()
}

protocol CategoryFoodInteractorOutputProtocol: AnyObject {
    func recieveFood(_ food: [FoodRealm], categoryName: String)
}
