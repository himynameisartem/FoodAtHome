//
//  ShoppingListWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class ShoppingListWorker {
    
    func prepareShoppingList(from food: [FoodRealm]) -> [ShoppingListModel.ShowFood.ViewModel.DisplayedFood] {
        var result: [ShoppingListModel.ShowFood.ViewModel.DisplayedFood] = []
        food.forEach { food in
            let name = food.name.localized()
            let imageName = food.name
            let calories = food.calories
            let isShoppingList = food.isShoppingList
            let weight = food.weight
            let unit = food.unit.localized()
            
            let food = ShoppingListModel.ShowFood.ViewModel.DisplayedFood(name: name, imageName: imageName, calories: calories, isShoppingList: isShoppingList, weight: weight, unit: unit)
            result.append(food)
        }
        return result
    }
    
    func prepareToMyFoodList(from list: FoodRealm, and food: [FoodRealm]) -> FoodRealm {
        var myFood = FoodRealm()
        for i in food {
            if list.name == i.name {
                myFood = i
            }
        }
        return myFood
    }
}
