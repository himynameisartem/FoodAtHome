//
//  CategoryDetailsWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.07.2024.
//

import UIKit

class CategoryDetailsWorker {
    
    func getDisplayedFood(food: [FoodRealm]) -> [CategoryDetails.ShowDetails.ViewModel.DisplayedDetails] {
        var displayedFood: [CategoryDetails.ShowDetails.ViewModel.DisplayedDetails] = []
        
        food.forEach { food in
            let foodName = food.name
            let imageName = food.name
            let weight = food.weight
            let calories = food.calories
            
            let foodDetails = CategoryDetails.ShowDetails.ViewModel.DisplayedDetails(
                foodName: foodName,
                imageName: imageName,
                weight: weight,
                calories: calories + "kCal.".localized() + " / " + "100g.".localized())
            
            displayedFood.append(foodDetails)
        }
        
        return displayedFood
    }
    
}
