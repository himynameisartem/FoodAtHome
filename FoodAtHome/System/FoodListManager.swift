//
//  FoodListManager.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 02.08.2023.
//

import Foundation

var foodCatigoriesList = ["Vegetables", "Fruits and Berries", "Mushrooms", "Eggs and Dairy Products",  "Meat Products", "Fish and Seafood", "Nuts and Dried Fruits", "Flour and Bakery Products",  "Grains and Porridge", "Sweets and Confectionery", "Greens and Herbs", "Spices and Seasonings", "Raw Materials and Additives", "Baby Food", "Soft Drinks", "Alcoholic Drinks"]

class FoodListManager {
    static let shared = FoodListManager()
    
    func choiseCategories(for slectedRow: Int) -> [FoodRealm] {
        switch slectedRow {
        case 0: return vegitables.sorted { $0.name.localized() < $1.name.localized() }
        case 1: return fruitsAndBerries.sorted { $0.name.localized() < $1.name.localized() }
        case 2: return mushrooms.sorted { $0.name.localized() < $1.name.localized() }
        case 3: return eggsAndDairyProducts.sorted { $0.name.localized() < $1.name.localized() }
        case 4: return meatProducts.sorted { $0.name.localized() < $1.name.localized() }
        case 5: return fishAndSeafood.sorted { $0.name.localized() < $1.name.localized() }
        case 6: return nutsAndDriedFruits.sorted { $0.name.localized() < $1.name.localized() }
        case 7: return flourAndBakeryProducts.sorted { $0.name.localized() < $1.name.localized() }
        case 8: return grainsAndPorridge.sorted { $0.name.localized() < $1.name.localized() }
        case 9: return sweetsAndConfectionery.sorted { $0.name.localized() < $1.name.localized() }
        case 10: return greensAndHerbs.sorted { $0.name.localized() < $1.name.localized() }
        case 11: return spicesAndSeasonings.sorted { $0.name.localized() < $1.name.localized() }
        case 12: return rawMaterialsAndAdditives.sorted { $0.name.localized() < $1.name.localized() }
        case 13: return babyFood.sorted { $0.name.localized() < $1.name.localized() }
        case 14: return softDrinks.sorted { $0.name.localized() < $1.name.localized() }
        case 15: return alcoholicDrinks.sorted { $0.name.localized() < $1.name.localized() }
        default:
            return vegitables.sorted { $0.name.localized() < $1.name.localized() }
        }
    }
    
    
}
