//
//  FoodModel.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.05.2022.
//

import Foundation
import RealmSwift

enum FoodType: String {
    case vegetables, fruitsAndBerries, mushrooms, eggsAndDairyProducts, meatProducts, fishAndSeafood, nutsAndDriedFruits, flourAndFlourProducts,
         cereals, confectioneryAndSweets, greensAndFlowers, spices, additives, babyFood, softDrinks, alcoholicDrinks
}

class FoodRealm: Object {
     
    @Persisted var name: String
    @Persisted var type: FoodType.RawValue
    @Persisted var weight = "0.0"
    @Persisted var unit = ""
    @Persisted var productionDate: Date? = nil
    @Persisted var expirationDate: Date? = nil
    @Persisted var consumeUp: Date? = nil
    @Persisted var calories = "0"
    
    convenience  init(name: String, type: FoodType) {
        self.init()
        self.name = name
        self.type = type.rawValue
    }
}

//class FoodRealm {
//
//    var name: String
//    var type: FoodType
//    var weight = "0.0"
//    var unit = ""
//    var productionDate: Date? = nil
//    var expirationDate: Date? = nil
//    var consumeUp: Date? = nil
//    var calories = "0"
//
//
//    init(name: String, type: FoodType) {
//
//        self.name = name
//        self.type = type
//    }
//}

class Vegetables: FoodRealm {
    
}

class FruitsAndBerries: FoodRealm {
    
}

class Mushrooms: FoodRealm {
    
}

