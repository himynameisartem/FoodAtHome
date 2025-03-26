//
//  DataManager.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 23.04.2024.
//

import Foundation
import RealmSwift


struct FoodItem: Codable {
    let name: String
    let type: String
    let calories: String
}

struct DataManager {
    static let shared = DataManager()
    private let localRealm = try! Realm()
}
//MARK: - fetchMyFood

extension DataManager {
    
    func fetchFoodData(completion: @escaping (_ food: [FoodItem])->()) {
        guard let url = Bundle.main.url(forResource: "food_database", withExtension: "json"),
        let data = try? Data(contentsOf: url) else { return }
        let decoder = JSONDecoder()
        guard let allItems = try? decoder.decode([FoodItem].self, from: data) else { return }
        completion(allItems)
    }
    
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
        let allFood = Array(localRealm.objects(FoodRealm.self)).filter {!$0.isShoppingList}
        try! localRealm.write {
            allFood.forEach { foodName in
                if foodName.name == food.name {
                    localRealm.delete(foodName)
                }
            }
            localRealm.add(food)
        }
    }
    
    func changeFoodForShoppingList(_ food: FoodRealm) {
        let allFood = Array(localRealm.objects(FoodRealm.self)).filter {$0.isShoppingList}
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
        let allFood = Array(localRealm.objects(FoodRealm.self)).filter {!$0.isShoppingList}
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
    
    func updateFoodForShoppingList(_ food: FoodRealm) {
        let allFood = Array(localRealm.objects(FoodRealm.self)).filter {$0.isShoppingList}
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
        let results = Array(localRealm.objects(FoodRealm.self)).filter {!$0.isShoppingList}
        return results.contains(where: { $0.name == food.name })
    }
    
    func checkShoppingListDuplicate(food: FoodRealm) -> Bool {
        let results = Array(localRealm.objects(FoodRealm.self)).filter {$0.isShoppingList}
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
