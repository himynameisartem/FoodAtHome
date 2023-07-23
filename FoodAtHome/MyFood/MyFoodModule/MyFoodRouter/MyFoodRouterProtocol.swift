//
//  MyFoodRouterProtocol.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 04.07.2023.
//

import UIKit

protocol MyFoodRouterProtocol {
    func openCategoryFoodViewController(at indexPath: IndexPath, food: [FoodRealm])
}
