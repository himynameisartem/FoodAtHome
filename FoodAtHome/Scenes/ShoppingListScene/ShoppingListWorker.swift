//
//  ShoppingListWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class ShoppingListWorker {
    
    func getShoppintList() -> [FoodRealm] {
        let allFood = DataManager.shared.fetchMyShoppingList()
        let shoppingList = allFood.filter { $0.isShoppingList }
        return shoppingList
    }
    
    func prepareShoppingList(from food: [FoodRealm]) -> [ShoppingList.ShoppingListModel.ViewModel.DisplayedFood] {
        var result: [ShoppingList.ShoppingListModel.ViewModel.DisplayedFood] = []
        food.forEach { food in
            let name = food.name
            let imageName = food.name
            let calories = food.calories
            let weight = food.weight
            
            let food = ShoppingList.ShoppingListModel.ViewModel.DisplayedFood(name: name, imageName: imageName, calories: calories, weight: weight)
            result.append(food)
        }
        return result
    }
}
