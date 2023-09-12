//
//  ShoppingListPresenterProtocol.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 06.09.2023.
//

import Foundation

protocol ShoppingListPresenterProtocol: AnyObject {
    var shoppingList: [FoodRealm] { get }
    func viewDidLoad()
    func showFoodListViewController()
}
