//
//  FoodManager.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 29.06.2023.
//

import Foundation
import RealmSwift

class FoodManager {
    
    let localRealm = try! Realm()
    
    static let shared = FoodManager()
    
    func fetchMyFood() -> [FoodRealm] {
        let results = localRealm.objects(FoodRealm.self)
        return Array(results)
    }
    
    func addFood(_ food: FoodRealm, myFood foodArray: [FoodRealm]) {
        
        var foundMatch = false
        
        for i in foodArray {
            if food.name == i.name {
                let index = foodArray.firstIndex(of: i)!
                try! localRealm.write({
                    foodArray[index].weight = food.weight
                    foodArray[index].unit = food.unit
                    foodArray[index].productionDate = food.productionDate
                    foodArray[index].expirationDate = food.expirationDate
                    foodArray[index].consumeUp = food.consumeUp
                })
                foundMatch = true
                break
            }
        }
        
        if !foundMatch {
            try! localRealm.write({
                localRealm.add(food)
            })
        }
    }
    
    func fetchMyShoppingList() {
        
    }
    
}
