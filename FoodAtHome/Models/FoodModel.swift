//
//  FoodModel.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.05.2022.
//

import Foundation
import RealmSwift

enum FoodType: String {
    case vegetables, 
         fruitsAndBerries,
         mushrooms,
         eggsAndDairyProducts,
         meatProducts,
         fishAndSeafood,
         nutsAndDriedFruits,
         flourAndBakeryProducts,
         grainsAndPorridge, 
         sweetsAndConfectionery,
         greensAndHerbs,
         spicesAndSeasonings,
         rawMaterialsAndAdditives,
         babyFood,
         softDrinks,
         alcoholicDrinks
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
    @Persisted var isShoppingList: Bool = false
    
    convenience  init(name: String, type: FoodType, calories: String) {
        self.init()
        self.name = name
        self.type = type.rawValue
        self.calories = calories
    }
}

class ShoppingList: FoodRealm {}

class Vegetables: FoodRealm {}
class FruitsAndBerries: FoodRealm {}
class Mushrooms: FoodRealm {}
class EggsAndDairyProducts: FoodRealm {}
class MeatProducts: FoodRealm {}
class FishAndSeafood: FoodRealm {}
class NutsAndDriedFruits: FoodRealm {}
class FlourAndBakeryProducts: FoodRealm {}
class GrainsAndPorridge: FoodRealm {}
class SweetsAndConfectionery: FoodRealm {}
class GreensAndHerbs: FoodRealm {}
class SpicesAndSeasonings: FoodRealm {}
class RawMaterialsAndAdditives: FoodRealm {}
class BabyFood: FoodRealm {}
class SoftDrinks: FoodRealm {}
class AlcoholicDrinks: FoodRealm {}
