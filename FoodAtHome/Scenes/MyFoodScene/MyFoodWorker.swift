//
//  MyFoodWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 12.04.2024.
//

import UIKit
import RealmSwift

protocol MyFoodWorkerProtocol {
    func fetchMyFood() -> [FoodRealm]
    func prepareFoodForRouting(source: [FoodRealm], type: String) -> [FoodRealm]
    func deleteFood(at indexPath: IndexPath)
    func removeAllFood()
}

class MyFoodWorker: MyFoodWorkerProtocol {
    
    func fetchMyFood() -> [FoodRealm] {
        return DataManager.shared.fetchMyFood()
    }
    
    func deleteFood(at indexPath: IndexPath) {
        let items = DataManager.shared.fetchMyFood()
        return DataManager.shared.delete(food: items[indexPath.row])
    }
    
    func prepareFoodForRouting(source: [FoodRealm], type: String) -> [FoodRealm] {
        source.filter { $0.type == type }
    }
    
    func removeAllFood() {
        DataManager.shared.reamoveAllMyFood()
    }
}
