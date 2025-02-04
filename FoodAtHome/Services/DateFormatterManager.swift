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
    private let dateFormatter: DateFormatter

    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
    }

    func formatDate(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }

    func formatConsumeUp(_ consumeUp: ConsumeUp?) -> String {
        guard let consumeUp = consumeUp else { return "N/A" }
        return "\(consumeUp.months ?? 0)m. \(consumeUp.days ?? 0)d."
    }

    func formatDaysLeft(_ daysLeft: (months: Int, days: Int, isOverdue: Bool)?) -> String {
        guard let daysLeft = daysLeft else { return "N/A" }
        return daysLeft.isOverdue ? "Overdue" : "\(daysLeft.months)m. \(daysLeft.days)d."
    }
}
