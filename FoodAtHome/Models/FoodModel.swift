//
//  FoodMode.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.05.2022.
//

import Foundation
import RealmSwift


enum FoodType: String, CaseIterable {
    case vegetables = "Vegetables"
    case fruitsAndBerries = "Fruits and Berries"
    case mushrooms = "Mushrooms"
    case eggsAndDairyProducts = "Eggs and Dairy Products"
    case meatProducts = "Meat Products"
    case fishAndSeafood = "Fish and Seafood"
    case nutsAndDriedFruits = "Nuts and Dried Fruits"
    case flourAndBakeryProducts = "Flour and Bakery Products"
    case grainsAndPorridge = "Grains and Porridge"
    case sweetsAndConfectionery = "Sweets and Confectionery"
    case greensAndHerbs = "Greens and Herbs"
    case spicesAndSeasonings = "Spices and Seasonings"
    case rawMaterialsAndAdditives = "Raw Materials and Additives"
    case babyFood = "Baby Food"
    case softDrinks = "Soft Drinks"
    case alcoholicDrinks = "Alcoholic Drinks"
}

class ConsumeUp: Object {
    @Persisted var months: Int?
    @Persisted var days: Int?
    
    convenience init(months: Int?, days: Int?) {
        self.init()
        self.months = months
        self.days = days
    }
    
    func getString() -> String {
        return "\(months ?? 0)\("m.".localized()) \(days ?? 0)\("d.".localized())"
    }
}

class FoodRealm: Object {
    @Persisted var name: String
    @Persisted var type: FoodType.RawValue
    @Persisted var weight: String = ""
    @Persisted var unit: String = ""
    @Persisted var calories: String = "0"
    @Persisted var isShoppingList: Bool = false
    @Persisted var productionDate: Date?
    @Persisted var expirationDate: Date?
    @Persisted var consumeUp: ConsumeUp?

    convenience init(name: String, type: FoodType, calories: String) {
        self.init()
        self.name = name
        self.type = type.rawValue
        self.calories = calories
    }
    
    convenience init(name: String, type: FoodType, weight: String, unit: String, calories: String) {
        self.init()
        self.name = name
        self.type = type.rawValue
        self.weight = weight
        self.unit = unit
        self.calories = calories
    }
    
    convenience init(name: String, type: FoodType, weight: String, unit: String, calories: String, isShoppingList: Bool, productionDate: Date?, expirationDate: Date?, consumeUp: ConsumeUp?) {
        self.init()
        self.name = name
        self.type = type.rawValue
        self.weight = weight
        self.unit = unit
        self.calories = calories
        self.isShoppingList = isShoppingList
        self.productionDate = productionDate
        self.expirationDate = expirationDate
        self.consumeUp = consumeUp
    }
}
