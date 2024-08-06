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

extension DataManager {
    
    func fetchMyFood() -> [FoodRealm] {
        let results = localRealm.objects(FoodRealm.self)
        return Array(results).filter { !$0.isShoppingList }
    }
}
