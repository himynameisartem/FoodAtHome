//
//  MyFoodRouterProtocol.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 04.07.2023.
//

import UIKit

protocol OldMyFoodRouterProtocol {
    func openCategoryFoodViewController(at indexPath: IndexPath, food: [FoodRealm])
    func openFoodListViewController()
}
