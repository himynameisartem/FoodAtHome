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

class FoodManager {
    
    let localRealm = try! Realm()
    
    static let shared = FoodManager()
    var menuStatus: ClosedAddFoodViewStatus = .didClosedMenu
    
    func fetchMyFood() -> [FoodRealm] {
        let results = localRealm.objects(FoodRealm.self)
        return Array(results)
    }
    
    func addFood(_ food: FoodRealm, myFood foodArray: [FoodRealm], viewController: UIViewController) {
        
        var foundMatch = false
        menuStatus = .didClosedMenu
        
        if food.weight == "0.0" {
            let alert = UIAlertController(title: "Enter the weight of the product".localized(), message: nil, preferredStyle: .alert)
            let oklAction = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(oklAction)
            viewController.present(alert, animated: true)
            menuStatus = .didNotClosedMenu
        } else {
            for i in foodArray {
                
                if food.name == i.name {
                    
                    menuStatus = .didNotClosedMenu
                    
                    let alert = UIAlertController(title: "You already have this product".localized(), message: "Do you want to replace it?".localized(), preferredStyle: .alert)
                    let yesAction = UIAlertAction(title: "Yes".localized(), style: .default) { done in
                        let index = foodArray.firstIndex(of: i)!
                        try! self.localRealm.write({
                            foodArray[index].weight = food.weight
                            foodArray[index].unit = food.unit
                            foodArray[index].productionDate = food.productionDate
                            foodArray[index].expirationDate = food.expirationDate
                            foodArray[index].consumeUp = food.consumeUp
                        })
                    }
                    let noAction = UIAlertAction(title: "No".localized(), style: .default)

                    foundMatch = true
                    
                    alert.addAction(yesAction)
                    alert.addAction(noAction)
                    viewController.present(alert, animated: true)
                    
                    break
                }
            }
            if !foundMatch {
                try! localRealm.write({
                    localRealm.add(food)
                })
            }
        }
    }
    
    func fetchMyShoppingList() {
        
    }
    
}
