//
//  CategoryDetailsWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.07.2024.
//

import UIKit

class CategoryDetailsWorker {
    
    func getDisplayedFood(food: [FoodRealm]) -> [CategoryDetails.ShowFood.ViewModel.DisplayedCells] {
        var displayedFood: [CategoryDetails.ShowFood.ViewModel.DisplayedCells] = []
        
        food.forEach { food in
            let foodName = food.name
            let imageName = food.name
            let weight = food.weight
            let calories = food.calories
            
            let foodDetails = CategoryDetails.ShowFood.ViewModel.DisplayedCells(
                foodName: foodName,
                imageName: imageName,
                weight: weight,
                calories: calories + "kCal.".localized() + " / " + "100g.".localized())
            
            displayedFood.append(foodDetails)
        }
        return displayedFood
    }
    
}
