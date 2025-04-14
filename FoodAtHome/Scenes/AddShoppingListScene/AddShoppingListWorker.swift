//
//  AddShoppingListWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.02.2025.
//

import UIKit

class AddShoppingListWorker {
    func getImage(from foodName: String) -> UIImage {
        let image = UIImage(named: foodName) ?? UIImage()
        return image
    }
    
    func getFoodForShoppingList(from food: FoodRealm, and request: AddShoppingListModel.AddFood.Request) -> FoodRealm {
        let food = FoodRealm(name: food.name, type: FoodType(rawValue: food.type)!, weight: request.weight, unit: request.unit, calories: food.calories)
        food.isShoppingList = true
        return food
    }
}
