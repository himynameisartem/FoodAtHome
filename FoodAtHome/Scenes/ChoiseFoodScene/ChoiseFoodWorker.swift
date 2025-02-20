//
//  ChoiseFoodWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2024.
//

import UIKit

class ChoiseFoodWorker {
    
    func displayedFood(from foodList: [FoodItem]) -> [ChoiseFood.ShowFood.ViewModel.DispalyedFood] {
        var displayedFood = [ChoiseFood.ShowFood.ViewModel.DispalyedFood]()
        foodList.forEach { food in
            let name = food.name
            let imageName = food.name
            let calories = food.calories
            let buildFood = ChoiseFood.ShowFood.ViewModel.DispalyedFood(name: name, imageName: imageName, calories: calories)
            displayedFood.append(buildFood)
        }
        return displayedFood.sorted {$0.name.localized() < $1.name.localized()}
    }
    
    func getFoodForAddFoodMenu(from foodName: String) -> FoodRealm {
        let responce = FoodRealm()
        DataManager.shared.fetchFoodData { food in
            guard let food = food.first(where: {$0.name == foodName}) else { return }
            responce.name = food.name
            responce.type = food.type
            responce.calories = food.calories
        }
        return responce
    }
}
