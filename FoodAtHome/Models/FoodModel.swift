//
//  FoodModel.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.05.2022.
//

import Foundation

enum FoodType {
    case vegetables, fruitsAndBerries, mushrooms, eggsAndDairyProducts, meatProducts, fishAndSeafood, nutsAndDriedFruits, flourAndFlourProducts,
         cereals, confectioneryAndSweets, greensAndFlowers, spices, additives, babyFood, softDrinks, alcoholicDrinks
}

class Food {
    
    var name: String
    var type: FoodType
    var weight = "0.0"
    var unit = ""
    var productionDate: Date? = nil
    var expirationDate: Date? = nil
    var consumeUp: Date? = nil

    
    init(name: String, type: FoodType) {
        
        self.name = name
        self.type = type
    }
}

class Vegetables: Food {
    
}

class FruitsAndBerries: Food {
    
}

class Mushrooms: Food {
    
}

