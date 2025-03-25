//
//  DateFormatterManager.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 13.01.2025.
//

import Foundation

protocol DateFormatterManagerProtocol {
    func formatDate(_ date: Date) -> String
    func formatConsumeUp(_ consumeUp: ConsumeUp?) -> String
    func formatDaysLeft(_ daysLeft: (months: Int, days: Int, isOverdue: Bool)?) -> String
}

class DateFormatterManager: DateFormatterManagerProtocol {
    
    static let shared = DateFormatterManager()
    
    private let dateFormatter: DateFormatter

    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
    }

    func formatDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func formatDateFrom(string: String) -> Date? {
        return dateFormatter.date(from: string)
    }

    func formatConsumeUp(_ consumeUp: ConsumeUp?) -> String {
        guard let consumeUp = consumeUp else { return "" }
        return "\(consumeUp.months ?? 0)m. \(consumeUp.days ?? 0)d."
    }

    func formatDaysLeft(_ daysLeft: (months: Int, days: Int, isOverdue: Bool)?) -> String {
        guard let daysLeft = daysLeft else { return "" }
        return daysLeft.isOverdue ? "Overdue" : "\(daysLeft.months)m. \(daysLeft.days)d."
    }
}
