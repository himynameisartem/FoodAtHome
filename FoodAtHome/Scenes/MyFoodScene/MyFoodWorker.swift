//
//  MyFoodWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 12.04.2024.
//

import UIKit
import RealmSwift

class MyFoodWorker {
    
    func getDisplayedMyFood(from myFood: [FoodRealm]) -> [MyFood.ShowMyFood.ViewModel.DisplayedMyFood] {
        
        var displayedMyFood: [MyFood.ShowMyFood.ViewModel.DisplayedMyFood] = []
        myFood.forEach { food in
            let name = food.name
            let food = MyFood.ShowMyFood.ViewModel.DisplayedMyFood(name: name)
            displayedMyFood.append(food)
        }
        return displayedMyFood
    }
    
    func getDisplayedCategories(from categories: [String]) -> [MyFood.ShowCategories.ViewModel.DiplayedCategories] {
        
        var displayedCategories: [MyFood.ShowCategories.ViewModel.DiplayedCategories] = []
        categories.forEach { category in
            let name = category
            let imageName = category
            let categories = MyFood.ShowCategories.ViewModel.DiplayedCategories(name: name, imageName: imageName)
            displayedCategories.append(categories)
        }
        return displayedCategories
    }
    
    func getDisplayedFoodDetails(from myFood: [FoodRealm]) -> [MyFood.showDetailFood.ViewModel.DiplayedDetails] {
        var foodDetails: [MyFood.showDetailFood.ViewModel.DiplayedDetails] = []
        myFood.forEach { food in
            let name = food.name
            let weight = food.weight
            let productionDate = food.productionDateString() ?? "-"
            let expirationDate = food.expirationDateString() ?? "-"
            let consumeUp = food.consumeUpString() ?? "-"
            let distaceIndicator = food.distanceBetweenProductionAndExpiration()
            let food = MyFood.showDetailFood.ViewModel.DiplayedDetails(name: name,
                                                                              weight: weight,
                                                                              productionDate: productionDate,
                                                                              expirationDate: expirationDate,
                                                                              consumeUp: consumeUp,
                                                                              distaceIndicator: distaceIndicator)
            foodDetails.append(food)
        }

        return foodDetails
    }
    
    func getFoodForRouting(source: [FoodRealm], type: String) -> [FoodRealm] {
        source.filter { $0.type == type }
    }
}
