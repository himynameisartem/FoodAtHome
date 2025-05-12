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
    
    func checkFoDuplicates(food: FoodRealm) -> Bool {
        let results = Array(localRealm.objects(FoodRealm.self)).filter {!$0.isShoppingList}
        return results.contains(where: { $0.name == food.name })
    }
    
    func checkShoppingListDuplicate(food: FoodRealm) -> Bool {
        let results = Array(localRealm.objects(FoodRealm.self)).filter {$0.isShoppingList}
        return results.contains(where: { $0.name == food.name })
    }
}

//MARK: - write change and delete food

extension DataManager {
    
    func writeFood(_ food: FoodRealm) {
        try! localRealm.write {
            localRealm.add(food)
        }
    }
    
    func changeAndEdit(_ food: FoodRealm) {
        let myFood = fetchMyFood()
        let shoppingList = fetchMyShoppingList()
        try! localRealm.write {
            if myFood.contains(where: { $0.name == food.name }) {
                if let existingFood = myFood.first(where: { $0.name == food.name }) {
                    existingFood.weight = food.weight
                    existingFood.expirationDate = food.expirationDate
                    existingFood.productionDate = food.productionDate
                    existingFood.consumeUp = food.consumeUp
                    existingFood.unit = food.unit
                }
                if let shoppingItem = shoppingList.first(where: { $0.name == food.name }) {
//                    localRealm.delete(shoppingItem)
                }
            } else {
                if shoppingList.contains(where: { $0.name == food.name }) {
                    if let existingFood = shoppingList.first(where: { $0.name == food.name }) {
                        existingFood.weight = food.weight
                        existingFood.expirationDate = food.expirationDate
                        existingFood.productionDate = food.productionDate
                        existingFood.consumeUp = food.consumeUp
                        existingFood.unit = food.unit
                    }
                    shoppingList.filter({$0.name == food.name}).first?.isShoppingList = false
                }
            }
        }
    }
    
    func checkMyFoodListDuplicate(foodName: String) -> Bool {
        let results = Array(localRealm.objects(FoodRealm.self)).filter {!$0.isShoppingList}
        return results.contains(where: { $0.name == foodName })
    }
    
    func delete(food: FoodRealm) {
        try! localRealm.write({
            localRealm.delete(food)
        })
    }
    
    func reamoveAllMyFood() {
        let myFood = fetchMyFood()
        try! localRealm.write({
            myFood.forEach {$0.isShoppingList == false ? localRealm.delete($0) : ()}
        })
    }
    
    func removeAllShoppingList() {
        let shoppingList = fetchMyShoppingList()
        try! localRealm.write {
            shoppingList.forEach {$0.isShoppingList == true ? localRealm.delete($0) : ()}
        }
    }
}
