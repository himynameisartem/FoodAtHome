//
//  DateManager.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 11.07.2023.
//

import Foundation

protocol DateCalculatorManagerProtocol {
    func calculateConsumeUp(productionDate: Date, expirationDate: Date) -> ConsumeUp?
    func calculateDaysLeft(expirationDate: Date) -> (months: Int, days: Int, isOverdue: Bool)?
    func calculateExpirationDistance(productionDate: Date?, expirationDate: Date?) -> CGFloat?
}

class DateCalculatorManager: DateCalculatorManagerProtocol {
    private let calendar: Calendar = .current

    func calculateConsumeUp(productionDate: Date, expirationDate: Date) -> ConsumeUp? {
        guard expirationDate > productionDate else { return nil }
        let components = calendar.dateComponents([.month, .day], from: productionDate, to: expirationDate)
        return ConsumeUp(months: components.month, days: components.day)
    }

    func calculateDaysLeft(expirationDate: Date) -> (months: Int, days: Int, isOverdue: Bool)? {
        let components = calendar.dateComponents([.month, .day], from: Date(), to: expirationDate)
        guard let months = components.month, let days = components.day else { return nil }
        let isOverdue = months < 0 || days < 0
        return (abs(months), abs(days), isOverdue)
    }

    func calculateExpirationDistance(productionDate: Date?, expirationDate: Date?) -> CGFloat? {
        guard let productionDate = productionDate, let expirationDate = expirationDate else { return nil }
        let totalDays = calendar.dateComponents([.day], from: productionDate, to: expirationDate).day ?? 0
        let currentDays = calendar.dateComponents([.day], from: Date(), to: expirationDate).day ?? 0
        guard totalDays > 0 else { return nil }
        return CGFloat(currentDays + 1) / CGFloat(totalDays)
    }
}
