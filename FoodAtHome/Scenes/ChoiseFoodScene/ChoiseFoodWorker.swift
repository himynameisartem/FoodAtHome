//
//  ChoiseFoodWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class ChoiseFoodWorker {
    
    func showFood(from categories: FoodType?) -> [FoodRealm] {
        var foodList: [FoodRealm] = []
        
        guard let categories = categories else { return foodList }
        
        switch categories {
        case .vegetables:
            foodList = vegitables
        case .fruitsAndBerries:
            foodList = fruitsAndBerries
        case .mushrooms:
            foodList = mushrooms
        case .eggsAndDairyProducts:
            foodList = eggsAndDairyProducts
        case .meatProducts:
            foodList = meatProducts
        case .fishAndSeafood:
            foodList = fishAndSeafood
        case .nutsAndDriedFruits:
            foodList = nutsAndDriedFruits
        case .flourAndBakeryProducts:
            foodList = flourAndBakeryProducts
        case .grainsAndPorridge:
            foodList = grainsAndPorridge
        case .sweetsAndConfectionery:
            foodList = sweetsAndConfectionery
        case .greensAndHerbs:
                foodList = greensAndHerbs
        case .spicesAndSeasonings:
            foodList = spicesAndSeasonings
        case .rawMaterialsAndAdditives:
            foodList = rawMaterialsAndAdditives
        case .babyFood:
            foodList = babyFood
        case.softDrinks:
            foodList = softDrinks
        case.alcoholicDrinks:
            foodList = alcoholicDrinks
        }
        
        return foodList
    }
    
    func displayedFood(from foodList: [FoodRealm]) -> [ChoiseFood.ShowFood.ViewModel.DispalyedFood] {
        var displayedFood = [ChoiseFood.ShowFood.ViewModel.DispalyedFood]()
        foodList.forEach { food in
            let name = food.name.localized()
            let imageName = food.name
            let calories = food.calories
            let buildFood = ChoiseFood.ShowFood.ViewModel.DispalyedFood(name: name, imageName: imageName, calories: calories)
            displayedFood.append(buildFood)
        }
        return displayedFood.sorted {$0.name < $1.name}
    }
    
    func getFood(from food: ChoiseFood.ShowFood.ViewModel.DispalyedFood) -> FoodRealm {
        var foodRealm = FoodRealm()
        FoodManager.shared.allFood.forEach { foodStorage in
            if food.name.localized() == foodStorage.name.localized() {
                foodRealm = foodStorage
            }
        }
        return foodRealm
    }
}
