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
    
    func addFood(food: FoodRealm) {
        
    }
    
    func fetchMyShoppingList() {
        
    }
    
}
