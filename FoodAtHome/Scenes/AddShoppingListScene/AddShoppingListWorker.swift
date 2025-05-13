//
//  AddShoppingListWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.02.2025.
//

import UIKit

protocol AddShoppingListWorkerProtocol {
    func addFood(from food: FoodRealm, and request: AddShoppingListModel.ConfirmAddFood.Request)
    func changeFood(from food: FoodRealm, and request: AddShoppingListItemProtocol)
    func getImage(from foodName: String) -> UIImage
    func getFoodForShoppingList(from food: FoodRealm, and request: AddShoppingListModel.ConfirmAddFood.Request) -> FoodRealm
    func checkDuplicate(_ food: FoodRealm) -> Bool
}

class AddShoppingListWorker: AddShoppingListWorkerProtocol {
    
    func addFood(from food: FoodRealm, and request: AddShoppingListModel.ConfirmAddFood.Request) {
        let food = FoodRealm(name: food.name, type: FoodType(rawValue: food.type)!, weight: request.weight, unit: request.unit, calories: food.calories)
        food.isShoppingList = true
        DataManager.shared.writeFood(food)
    }
    
    func changeFood(from food: FoodRealm, and request: AddShoppingListItemProtocol) {
        let food = FoodRealm(name: food.name, type: FoodType(rawValue: food.type)!, weight: request.weight, unit: request.unit, calories: food.calories)
        DataManager.shared.changeShoppingListItem(food)
    }
    
    func getImage(from foodName: String) -> UIImage {
        let image = UIImage(named: foodName) ?? UIImage()
        return image
    }
    
    func getFoodForShoppingList(from food: FoodRealm, and request: AddShoppingListModel.ConfirmAddFood.Request) -> FoodRealm {
        let food = FoodRealm(name: food.name, type: FoodType(rawValue: food.type)!, weight: request.weight, unit: request.unit, calories: food.calories)
        food.isShoppingList = true
        return food
    }
    
    func checkDuplicate(_ food: FoodRealm) -> Bool {
        DataManager.shared.checkShoppingListDuplicate(food: food)
    }
}
