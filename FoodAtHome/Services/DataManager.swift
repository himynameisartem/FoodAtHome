//
//  DataManager.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 23.04.2024.
//

import Foundation
import RealmSwift

struct DataManager {
    
    static let shared = DataManager()
    
    private let localRealm = try! Realm()
    
}
//MARK: - fetchMyFood

extension DataManager {
    
    func fetchMyFood() -> [FoodRealm] {
//        print(localRealm.configuration.fileURL!.path)
        let results = localRealm.objects(FoodRealm.self)
        return Array(results).filter { !$0.isShoppingList }
    }
    
    func fetchMyShoppingList() -> [FoodRealm] {
//        print(localRealm.configuration.fileURL!.path)
        let results = localRealm.objects(FoodRealm.self)
        return Array(results).filter { $0.isShoppingList }
    }
}

//MARK: - write change and delete food

extension DataManager {
    func writeFood(_ food: FoodRealm) {
        try! localRealm.write {
            localRealm.add(food)
        }
    }
    
    func changeFood(_ food: FoodRealm) {
        let allFood = Array(localRealm.objects(FoodRealm.self))
        try! localRealm.write {
            allFood.forEach { foodName in
                if foodName.name == food.name {
                    localRealm.delete(foodName)
                }
            }
            localRealm.add(food)
        }
    }
    
    func updateFood(_ food: FoodRealm) {
        let allFood = Array(localRealm.objects(FoodRealm.self))
        var index = Int()
        for (i, j) in allFood.enumerated() {
            if j.name == food.name {
                index = i
            }
        }
        let update = allFood[index]
        try! localRealm.write {
            update.weight = food.weight
            update.productionDate = food.productionDate
            if food.expirationDate != nil {
                update.expirationDate = food.expirationDate
                update.consumeUp = food.consumeUp
            }
            update.unit = food.unit
        }
    }
    
    func checkFoDuplicates(food: FoodRealm) -> Bool {
        let results = Array(localRealm.objects(FoodRealm.self))
        return results.contains(where: { $0.name == food.name })
    }
    
    func delete(food: FoodRealm) {
        try! localRealm.write({
            localRealm.delete(food)
        })
    }
    
    func removeAll() {
        try! localRealm.write({
            localRealm.deleteAll()
        })
    }
}
