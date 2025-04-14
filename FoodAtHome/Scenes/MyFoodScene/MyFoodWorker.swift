//
//  MyFoodWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 12.04.2024.
//

import UIKit
import RealmSwift

class MyFoodWorker {
    
    var dateCalculator: DateCalculatorManagerProtocol?
    
    func prepareFoodForDisplay(_ food: [FoodRealm]) -> [MyFoodModel.FetchFoodList.ViewModel.DisplayedMyFood] {
        var displayedMyFood: [MyFoodModel.FetchFoodList.ViewModel.DisplayedMyFood] = []
        food.forEach { food in
            let name = food.name.localized()
            let imageName = food.name
            let indicator: Bool = {
                guard let productionDate = food.productionDate, let expirationDate = food.expirationDate else { return false }
                guard let daysLeft = dateCalculator?.calculateExpirationDistance(productionDate: productionDate, expirationDate: expirationDate) else { return false }
                if daysLeft <= 0.0 { return
                    true
                } else {
                    return false
                }
            }()
            let food = MyFoodModel.FetchFoodList.ViewModel.DisplayedMyFood(name: name, imageName: imageName, daysLeftIndicator: indicator)
            displayedMyFood.append(food)
        }
        return displayedMyFood
    }
    
    func prepareCategoriesForDisplay(_ categories: [String]) -> [MyFoodModel.FetchCategories.ViewModel.DiplayedCategories] {
        var displayedCategories: [MyFoodModel.FetchCategories.ViewModel.DiplayedCategories] = []
        categories.forEach { category in
            let name = category.localized()
            let imageName = category
            let categories = MyFoodModel.FetchCategories.ViewModel.DiplayedCategories(name: name, imageName: imageName)
            displayedCategories.append(categories)
        }
        return displayedCategories
    }
    
    func prepareFoodForRouting(source: [FoodRealm], type: String) -> [FoodRealm] {
        source.filter { $0.type == type }
    }
    
    func formatFoodForSharing(_ food: [FoodRealm]) -> String {
        var sharedFood = String()
        for i in food {
            if !i.isShoppingList {
                sharedFood += ("\(i.name.localized()): \(i.weight.localized()) \(i.unit.localized()) \n")
            }
        }
        return sharedFood
    }
}
