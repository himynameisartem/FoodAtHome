//
//  FoodManager.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 29.06.2023.
//

import Foundation
import RealmSwift

enum ClosedAddFoodViewStatus {
    case didClosedMenu, didNotClosedMenu
}

enum CheckForChangeOrAddition {
    case check, addition
}

enum ChioseShare {
    case shoppingList, MyFoodList
}

class FoodManager {
        
    static let shared = FoodManager()
    private let localRealm: Realm
    
    private init() {
        let config = Realm.Configuration(schemaVersion: 2)
        do {
            localRealm = try Realm(configuration: config)
        } catch {
            fatalError("Error initializing Realm: \(error)")
        }
    }
    
    func getRealm() -> Realm {
        return localRealm
    }
    
    var menuStatus: ClosedAddFoodViewStatus = .didClosedMenu
    
    func fetchAllFood() -> [FoodRealm] {
        let results = localRealm.objects(FoodRealm.self)
        return Array(results)
    }
    
    func fetchMyFoodList() -> [FoodRealm] {
        let results = localRealm.objects(FoodRealm.self).filter("isShoppingList == false")
        return Array(results)
    }
    
    func fetchMyShoppingList() -> [FoodRealm] {
        let results = localRealm.objects(FoodRealm.self).filter("isShoppingList == true")
        return Array(results)
    }
    
    func addFood(_ food: FoodRealm, myFood foodArray: [FoodRealm], check: CheckForChangeOrAddition, viewController: UIViewController, closedFunction: (() -> Void)?) {
        var foundMatch = false
        menuStatus = .didClosedMenu
        
        if food.weight == "0.0" || food.weight == "0" || food.weight == "" {
            let alert = UIAlertController(title: "Enter the weight of the product".localized(), message: nil, preferredStyle: .alert)
            let oklAction = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(oklAction)
            viewController.present(alert, animated: true)
            menuStatus = .didNotClosedMenu
        } else {
            for i in foodArray {
                let index = foodArray.firstIndex(of: i)!
                if food.name == i.name {
                    if check == .check {
                        menuStatus = .didNotClosedMenu
                        let alert = UIAlertController(title: "You already have this product".localized(), message: "Do you want to replace it?".localized(), preferredStyle: .alert)
                        let yesAction = UIAlertAction(title: "Yes".localized(), style: .default) { done in
                            closedFunction?()
                            try! self.localRealm.write({
                                foodArray[index].weight = food.weight
                                foodArray[index].unit = food.unit
                                foodArray[index].productionDate = food.productionDate
                                foodArray[index].expirationDate = food.expirationDate
                                foodArray[index].consumeUp = food.consumeUp
                            })
                            viewController.navigationController?.popToRootViewController(animated: true)
                        }
                        let noAction = UIAlertAction(title: "No".localized(), style: .default)
                        foundMatch = true
                        alert.addAction(yesAction)
                        alert.addAction(noAction)
                        viewController.present(alert, animated: true)
                        break
                    } else {
                        foundMatch = true
                        try! self.localRealm.write({
                            i.weight = food.weight
                            i.unit = food.unit
                            i.productionDate = food.productionDate
                            i.expirationDate = food.expirationDate
                            i.consumeUp = food.consumeUp
                            if i.expirationDate != nil && i.isShoppingList == true {
                                i.isShoppingList = false
                            }
                        })
                        viewController.navigationController?.popToRootViewController(animated: true)
                        break
                    }
                }
            }
            if !foundMatch {
                try! localRealm.write({
                    localRealm.add(food)
                })
            }
        }
    }
    
    func addFoodToShoppingList(_ food: FoodRealm) {
        try! localRealm.write({
            food.isShoppingList = true
            self.localRealm.add(food)
        })
    }
    
    func shareString(listType: ChioseShare) -> String {
        
        var food: [FoodRealm]
        if listType == .MyFoodList {
            food = fetchMyFoodList()
        } else {
            food = fetchMyShoppingList()
        }
        
        var shareText = ""
        
        for i in food {
            shareText += "\(i.name.localized()): \(i.weight)\(i.unit.localized()) \n"
        }
        
        return shareText
    }
}
