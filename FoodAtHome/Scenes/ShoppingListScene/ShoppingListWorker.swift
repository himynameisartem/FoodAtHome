//
//  ShoppingListWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

protocol ShoppingListWorkerProtocol {
    func fetchMyShoppingList() -> [FoodRealm]
    func checkDuplicate(food: FoodRealm) -> Bool
    func addToMyFoodList(_ food: FoodRealm)
    func changeMyFoodList(_ food: FoodRealm)
    func deleteItem(at indexPath: IndexPath)
    func removeAllShoppingList()
}

class ShoppingListWorker: ShoppingListWorkerProtocol {
    
    func fetchMyShoppingList() -> [FoodRealm] {
        DataManager.shared.fetchMyShoppingList()
    }
    
    func checkDuplicate(food: FoodRealm) -> Bool {
        DataManager.shared.checkFoodListDuplicates(food: food)
    }
    
    func addToMyFoodList(_ food: FoodRealm) {
        DataManager.shared.addItemToFoodList(food)
    }
    
    func changeMyFoodList(_ food: FoodRealm) {
        DataManager.shared.changeAndMoveItemToFoodList(food)
    }
    
    func deleteItem(at indexPath: IndexPath) {
        DataManager.shared.delete(food: fetchMyShoppingList()[indexPath.row])
    }
    
    func removeAllShoppingList() {
        DataManager.shared.removeAllShoppingList()
    }
}
