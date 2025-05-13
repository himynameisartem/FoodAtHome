//
//  FoodManager.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 29.06.2023.
//

import Foundation
import RealmSwift

protocol DateManagerProtocol {
    func format(date: Date) -> String
    func format(consumeUp: ConsumeUp?) -> String
    func format(daysLeft: (months: Int, days: Int, isOverdue: Bool)?) -> String
    
    func isExpired(_ productionDate: Date?, _ expirationDate: Date?) -> Bool
    func calculateExpirationProgress(_ productionDate: Date?, _ expirationDate: Date?) -> CGFloat?
    
    func getFormattedProductionDate(for food: FoodRealm) -> String?
    func getFormattedExpirationDate(for food: FoodRealm) -> String?
    func getFormattedConsumeUp(for food: FoodRealm) -> String?
    func getFormattedDaysLeft(for food: FoodRealm) -> String?
    
}

class DateManager: DateManagerProtocol {
    
    private let dateCalculator: DateCalculatorManagerProtocol
    private let dateFormatter: DateFormatterManagerProtocol

    init(dateCalculator: DateCalculatorManagerProtocol = DateCalculatorManager(),
         dateFormatter: DateFormatterManagerProtocol = DateFormatterManager()) {
        self.dateCalculator = dateCalculator
        self.dateFormatter = dateFormatter
    }
    
    func format(date: Date) -> String {
        dateFormatter.formatDate(date)
    }
    
    func format(consumeUp: ConsumeUp?) -> String {
        dateFormatter.formatConsumeUp(consumeUp)
    }
    
    func format(daysLeft: (months: Int, days: Int, isOverdue: Bool)?) -> String {
        dateFormatter.formatDaysLeft(daysLeft)
    }
    
    func isExpired(_ productionDate: Date?, _ expirationDate: Date?) -> Bool {
        dateCalculator.isExpired(productionDate, expirationDate)
    }
    
    func calculateExpirationProgress(_ productionDate: Date?, _ expirationDate: Date?) -> CGFloat? {
        dateCalculator.calculateExpirationDistance(productionDate: productionDate, expirationDate: expirationDate)
    }
    
    func getFormattedProductionDate(for food: FoodRealm) -> String? {
        guard let productionDate = food.productionDate else { return nil }
        return dateFormatter.formatDate(productionDate)
    }

    func getFormattedExpirationDate(for food: FoodRealm) -> String? {
        guard let expirationDate = food.expirationDate else { return nil }
        return dateFormatter.formatDate(expirationDate)
    }

    func getFormattedConsumeUp(for food: FoodRealm) -> String? {
        return dateFormatter.formatConsumeUp(food.consumeUp)
    }

    func getFormattedDaysLeft(for food: FoodRealm) -> String? {
        guard let expirationDate = food.expirationDate else { return nil }
        let daysLeft = dateCalculator.calculateDaysLeft(expirationDate: expirationDate)
        return dateFormatter.formatDaysLeft(daysLeft)
    }

    func calculateAndSetConsumeUp(for food: FoodRealm) {
        guard let productionDate = food.productionDate, let expirationDate = food.expirationDate else { return }
        food.consumeUp = dateCalculator.calculateConsumeUp(productionDate: productionDate, expirationDate: expirationDate)
    }
}
