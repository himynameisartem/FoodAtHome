//
//  ShoppingListInteractorProtocol.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 06.09.2023.
//

import Foundation

protocol ShoppingListInteractorProtocol: AnyObject {
    func fetchShoppingList()
    func fetchFoodList()
    func fetchAllFood()
}

protocol ShoppingListInteractorOutputProtocol: AnyObject {
    func shoppingListDidRecieve(_ food: [FoodRealm])
    func foodListDidRecieve(_ food: [FoodRealm])
    func allFoodDidRecieve(_ food: [FoodRealm])
}
