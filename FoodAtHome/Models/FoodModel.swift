//
//  FoodMode.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.05.2022.
//

import Foundation
import RealmSwift

enum FoodType: String, CaseIterable {
    case vegetables = "Vegetables"
    case fruitsAndBerries = "Fruits and Berries"
    case mushrooms = "Mushrooms"
    case eggsAndDairyProducts = "Eggs and Dairy Products"
    case meatProducts = "Meat Products"
    case fishAndSeafood = "Fish and Seafood"
    case nutsAndDriedFruits = "Nuts and Dried Fruits"
    case flourAndBakeryProducts = "Flour and Bakery Products"
    case grainsAndPorridge = "Grains and Porridge"
    case sweetsAndConfectionery = "Sweets and Confectionery"
    case greensAndHerbs = "Greens and Herbs"
    case spicesAndSeasonings = "Spices and Seasonings"
    case rawMaterialsAndAdditives = "Raw Materials and Additives"
    case babyFood = "Baby Food"
    case softDrinks = "Soft Drinks"
    case alcoholicDrinks = "Alcoholic Drinks"
}

class ConsumeUp: Object {
    @Persisted var months: Int?
    @Persisted var days: Int?
    
    convenience init(months: Int?, days: Int?) {
        self.init()
        self.months = months
        self.days = days
    }
}

class FoodRealm: Object {
    
    @Persisted var name: String
    @Persisted var type: FoodType.RawValue
    @Persisted var weight = "0.0"
    @Persisted var unit = ""
    @Persisted var calories = "0"
    @Persisted var isShoppingList: Bool = false
    @Persisted var productionDate: Date? {
        willSet {
            if expirationDate != nil {
                isUpdatingProductionDate = true
                setValueToConsumeUp(newValue: newValue)
            }
        }
    }
    @Persisted var expirationDate: Date? = nil {
        willSet {
            setValueToConsumeUp(newValue: newValue)
        }
    }
    @Persisted var consumeUp: ConsumeUp? = nil {
        willSet {
            setValueToExpirationDate(newValue: newValue)
        }
    }
    private var isUpdatingProductionDate = false
    private var isUpdateingExpirationDate = false
    private var isUpdatingConsumeUp = false
    private let dateFormatter = DateFormatter()
    private let calendar = Calendar.current
    private var dateComponents = DateComponents()
    
    convenience init(name: String, type: FoodType, calories: String) {
        self.init()
        self.name = name
        self.type = type.rawValue
        self.calories = calories
    }
}

extension FoodRealm {
    
    func productionDateString() -> String? {
        guard let productionDate = productionDate else { return nil }
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: productionDate)
    }
    
    func expirationDateString() -> String? {
        guard let expirationDate = expirationDate else { return nil }
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: expirationDate)
    }
    
    func consumeUpString() -> String? {
        guard let consumeUp = consumeUp else { return nil }
        let fullDate = "\(consumeUp.months ?? 0)м. \(consumeUp.days ?? 0)д."
        return fullDate
    }
    
    func daysLeftString() -> String? {
        guard let expirationDate = expirationDate else { return nil }
        dateComponents = calendar.dateComponents([.month, .day], from: Date(), to: expirationDate)
        let daysLeftString = "\(dateComponents.month ?? 0)м. \(dateComponents.day ?? 0)д."
        return daysLeftString
    }
    
    func distanceBetweenProductionAndExpiration() -> CGFloat? {
        guard let productionDate = productionDate, let expirationDate = expirationDate else { return nil }
        let fullDistance = calendar.dateComponents([.day], from: productionDate, to: expirationDate)
        let currentDistance = calendar.dateComponents([.day], from: Date(), to: expirationDate)
        let differenceDate = CGFloat(currentDistance.day! + 1) / CGFloat(fullDistance.day!)
        return CGFloat(differenceDate)
    }
    
    private func setValueToConsumeUp(newValue: Date?) {
        guard !isUpdatingConsumeUp else { return }
        let productionDate: Date!
        let expirationDate: Date!
        
        if isUpdatingProductionDate {
            productionDate = newValue
            expirationDate = self.expirationDate
            isUpdatingProductionDate = false
        } else {
            productionDate = self.productionDate
            expirationDate = newValue
            isUpdateingExpirationDate = false
        }
        if expirationDate > productionDate {
            isUpdateingExpirationDate = true
            dateComponents = calendar.dateComponents([.month, .day], from: productionDate, to: expirationDate)
            consumeUp = ConsumeUp(months: dateComponents.month, days: dateComponents.day)
            isUpdateingExpirationDate = false
        } else {
            consumeUp = nil
        }
    }
    
    private func setValueToExpirationDate(newValue: ConsumeUp?) {
        guard !isUpdateingExpirationDate, let productionDate = productionDate, let newValue = newValue else { return }
        isUpdatingConsumeUp = true
        dateComponents.month = newValue.months
        dateComponents.day = newValue.days
        expirationDate = calendar.date(byAdding: dateComponents, to: productionDate)
        isUpdatingConsumeUp = false
    }
}
