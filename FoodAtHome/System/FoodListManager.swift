//
//  FoodListManager.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 02.08.2023.
//

import Foundation

var foodCatigoriesList = ["Овощи" ,"Фрукты и ягоды" ,"Грибы" ,"Яйца и молочные продукты" ,"Мясные продукты" ,"Рыба и морепродукты" ,"Орехи и сухофрукты" ,"Мука и мучные изделия" ,"Крупы и каши" ,"Кондитерские изделия, сладости" ,"Зелень и цветы", "Специи и пряности", "Сырье и добавки", "Детское питание", "Безалкогольные напитки", "Алкогольные напитки"]

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
