//
//  MigrationManager.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 04.06.2025.
//

import Foundation
import RealmSwift

class MigrationManager {
    
    static let shared = MigrationManager()
    
    func migrateIfNeeded() {
        let defaults = UserDefaults.standard
        let isMigratedKey = "isMigrated"
        if !defaults.bool(forKey: isMigratedKey) {
            let realm = try! Realm()
            let oldObjects = realm.objects(FoodRealm.self)
            try! realm.write {
                for object in oldObjects {
                    if let englishName = LocalizationHelper.englishName(from: object.name) {
                        object.name = englishName
                    }
                    if object.type.first?.isLowercase == true {
                        let correctedType = object.type.prefix(1).uppercased() + object.type.dropFirst()
                        object.type = correctedType
                    }
                    if let englishUnit = LocalizationHelper.englishName(from: object.unit) {
                        object.unit = englishUnit
                    }
                }
            }
            defaults.set(true, forKey: isMigratedKey)
        }
    }
}
