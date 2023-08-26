//
//  FoodListManager.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 02.08.2023.
//

import Foundation

//var foodCatigoriesList = ["Vegetables".localized(), "Fruits and Berries".localized(), "Mushrooms".localized(), "Eggs and Dairy Products".localized(),  "Meat Products".localized(), "Fish and Seafood".localized(), "Nuts and Dried Fruits".localized(), "Flour and Bakery Products".localized(),  "Grains and Porridge".localized(), "Sweets and Confectionery".localized(), "Greens and Herbs".localized(), "Spices and Seasonings".localized(), "Raw Materials and Additives".localized(), "Baby Food".localized(), "Non-Alcoholic Beverages".localized(), "Alcoholic Beverages".localized()]

var foodCatigoriesList = ["Vegetables", "Fruits and Berries", "Mushrooms", "Eggs and Dairy Products",  "Meat Products", "Fish and Seafood", "Nuts and Dried Fruits", "Flour and Bakery Products",  "Grains and Porridge", "Sweets and Confectionery", "Greens and Herbs", "Spices and Seasonings", "Raw Materials and Additives", "Baby Food", "Non-Alcoholic Beverages", "Alcoholic Beverages"]

class FoodListManager {
    static let shared = FoodListManager()
    
    func choiseCategories(for slectedRow: Int) -> [FoodRealm] {
        switch slectedRow {
        case 0: return vegitables
        case 1: return fruitsAndBerries
        case 2: return mushrooms
        default:
            return vegitables
        }
    }
    
    
}
