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
}

//MARK: - writeFood

extension DataManager {
    func writeFood(_ food: FoodRealm) {
//        let realmFood = FoodRealm(from: food)
        try! localRealm.write {
            localRealm.add(food)
        }}
}
