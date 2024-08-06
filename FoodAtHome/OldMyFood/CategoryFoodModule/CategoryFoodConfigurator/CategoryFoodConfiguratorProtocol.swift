//
//  CategoryFoodConfiguratorProtocol.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2023.
//

import Foundation

protocol CategoryFoodConfiguratorProtocol: AnyObject {
    func configure(with view: CategoryListViewController, _ food: [FoodRealm], categoryName: String)
}
