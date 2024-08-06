//
//  FoodListRouterProtocol.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 02.08.2023.
//

import Foundation

protocol FoodListRouterProtocol: AnyObject {
    func openAddFoodView(_ food: FoodRealm)
    func backToRootViewController()
}
