//
//  ShoppingListWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

protocol ShoppingListWorkerProtocol {
    func fetchMyShoppingList() -> [FoodRealm]
    func checkDiplicate(food: FoodRealm) -> Bool
    func deleteItem(at indexPath: IndexPath)
    func removeAllShoppingList()
}

class ShoppingListWorker: ShoppingListWorkerProtocol {
    
    func fetchMyShoppingList() -> [FoodRealm] {
        DataManager.shared.fetchMyShoppingList()
    }
    
    func checkDiplicate(food: FoodRealm) -> Bool {
        DataManager.shared.checkFoDuplicates(food: food)
    }
    
    func deleteItem(at indexPath: IndexPath) {
        DataManager.shared.delete(food: fetchMyShoppingList()[indexPath.row])
    }
    
    func removeAllShoppingList() {
        DataManager.shared.removeAllShoppingList()
    }
}
