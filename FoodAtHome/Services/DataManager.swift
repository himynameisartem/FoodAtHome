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
    
    func checkFoodListDuplicates(food: FoodRealm) -> Bool {
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
    
    func addItemToFoodList(_ food: FoodRealm) {
        let shoppingList = fetchMyShoppingList()
        try! localRealm.write {
            if let shoppingListItem = shoppingList.first(where: {$0.name == food.name}) {
                shoppingListItem.expirationDate = food.expirationDate
                shoppingListItem.productionDate = food.productionDate
                shoppingListItem.consumeUp = food.consumeUp
                shoppingListItem.isShoppingList.toggle()
            } else {
                localRealm.add(food)
            }
        }
    }
    
    func changeAndMoveItemToFoodList(_ food: FoodRealm) {
        let foodList = fetchMyFood()
        let shoppingList = fetchMyShoppingList()
        try! localRealm.write {
            if let foodListItem = foodList.first(where: {$0.name == food.name}) {
                foodListItem.weight = food.weight
                foodListItem.expirationDate = food.expirationDate
                foodListItem.productionDate = food.productionDate
                foodListItem.consumeUp = food.consumeUp
                foodListItem.unit = food.unit
                if food.isShoppingList {
                    if let shoppingListItem = shoppingList.first(where: {$0.name == food.name}) {
                        localRealm.delete(shoppingListItem)
                    }
                }
            }
        }
    }
    
    func changeShoppingListItem(_ food: FoodRealm) {
        let shoppingList = fetchMyShoppingList()
        try! localRealm.write {
            if let shoppingListItem = shoppingList.first(where: {$0.name == food.name}) {
                shoppingListItem.weight = food.weight
                shoppingListItem.unit = food.unit
            }
        }
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
