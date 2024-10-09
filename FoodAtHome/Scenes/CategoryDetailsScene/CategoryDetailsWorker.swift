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
            let unit = food.unit
            let color: UIColor? = {
                guard let indicator = food.distanceBetweenProductionAndExpiration() else { return nil }
                if indicator < 1 && indicator > 0.4 {
                    return nil
                } else if indicator <= 0.4 && indicator > 0.0 {
                    return .orange
                } else if indicator == 0.0 {
                    return .red
                } else {
                    return nil
                }
            }()
            
            let foodDetails = CategoryDetails.ShowFood.ViewModel.DisplayedCells(
                foodName: foodName.localized(),
                imageName: imageName,
                weight: weight,
                calories: calories + " " + "kCal".localized() + " / " + "100g.".localized(),
                unit: unit.localized(),
                warningColor: color
            )
                
            
            displayedFood.append(foodDetails)
        }
        return displayedFood
    }
    
}
