//
//  AddFoodWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 13.01.2025.
//

import UIKit

class AddFoodWorker {
    
    func getImage(from foodName: String) -> UIImage {
        let image = UIImage(named: foodName) ?? UIImage()
        return image
    }
    
    func getFoodForAdding(from dataRequest: AddFoodModel.AddFood.Request, and food: FoodRealm) -> FoodRealm {
        let productionDate = dataRequest.prductionDate?.toDate()
        let expirationDate = dataRequest.expirationDate?.toDate()
        var consumeUp: ConsumeUp?
        if dataRequest.prductionDate != "" && dataRequest.expirationDate != "" {
            consumeUp = calculateConsumeUp(productionDate: dataRequest.prductionDate, expirationDate: dataRequest.expirationDate)
        }
        let food: FoodRealm = FoodRealm(name: food.name,
                                        type: FoodType(rawValue: food.type)!,
                                        weight: dataRequest.weight!,
                                        unit: dataRequest.unit,
                                        calories: food.calories,
                                        isShoppingList: food.isShoppingList,
                                        productionDate: productionDate,
                                        expirationDate: expirationDate,
                                        consumeUp: consumeUp
        )
        return food
    }
    
    func isEditingFood(_ view: UIView) -> Bool {
        var isEditing = Bool()
        if let tabBarController = view.window?.rootViewController as? UITabBarController {
            switch tabBarController.selectedIndex {
            case 0:
                isEditing = false
            case 1:
                if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                    if navigationController.viewControllers.count < 2 {
                        isEditing = true
                    } else {
                        isEditing = false
                    }
                }
            default:
                break
            }
        }
        return isEditing
    }
    
    func calculateConsumeUp(productionDate: String?, expirationDate: String?) -> ConsumeUp? {
        let calendar: Calendar = .current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
                
        guard let productionDate = dateFormatter.date(from: productionDate!), let expirationDate = dateFormatter.date(from: expirationDate!) else { return ConsumeUp(months: 0, days: 0) }
        guard expirationDate > productionDate else { return ConsumeUp(months: 0, days: 0) }
        
        let components = calendar.dateComponents([.month, .day], from: productionDate, to: expirationDate)
        return ConsumeUp(months: components.month, days: components.day)
    }
    
    func calculateExpirationDate(months: Int, days: Int, productionDate: String?) -> String? {
        let calendar: Calendar = .current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        guard let productionDate = dateFormatter.date(from: productionDate!) else { return nil }
        let consumeUp = ConsumeUp(months: months, days: days)
        let dateComponents = DateComponents(month: consumeUp.months ?? 0, day: consumeUp.days ?? 0)
        let expirationDate = calendar.date(byAdding: dateComponents, to: productionDate)!
        return dateFormatter.string(from: expirationDate)
    }
    
    func productionDatePickerValues(_ productionDate: String?) -> (maximumDate: Date, currentDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let currentDate = dateFormatter.date(from: productionDate ?? "") ?? Date()
        let maximumDate = Date()
        
        return (maximumDate, currentDate)
    }
    
    func expirationDatePickerValues(_ productionDate: String?, _ expirationDate: String?) -> (minimumDate: Date, currentDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let currentDate = dateFormatter.date(from: expirationDate ?? "") ?? Date()
        let minimumDate = dateFormatter.date(from: productionDate ?? "") ?? Date()
        
        return (minimumDate, currentDate)
    }
}
