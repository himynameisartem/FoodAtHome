//
//  DateManager.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 11.07.2023.
//

import Foundation

class DateManager {
    
    enum ExperationDateType {
        case experation, left
    }
    
    enum DaysOrMonths {
        case days, months
    }
    
    static let shared = DateManager()
    private var dateFormatter = DateFormatter()
    private let calendar = Calendar.current
    private let currentDate = Date()
    
    func dateFromString(with date: Date?) -> String {
        guard let date = date else { return ""}
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func stringFromDate(with string: String?) -> Date? {
        guard let string = string else { return nil }
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = .current
        let date = dateFormatter.date(from: string)
        return date
    }
    
    func intervalDate(from date1: Date?, to date2: Date?, type: ExperationDateType) -> String {
        guard let date1 = date1, let date2 = date2 else { return "" }
        var components = DateComponents()
            
        if type == .experation {
            components = calendar.dateComponents([.month, .day], from: date1, to: date2)
        } else {
            components = calendar.dateComponents([.month, .day], from: currentDate, to: date2)
        }
        
        if let months = components.month, let days = components.day {
            return "\(months)" + "м.".localized() + "\(days)" + "d.".localized()
        } else if let months = components.month {
            return "\(months)" + "m.".localized()
        } else if let days = components.day {
            return "\(days)" + "d.".localized()
        } else {
            return "0" + "d.".localized()
        }
    }
    
    func sellByDate(productedByDate: Date?, months: Int?, days: Int?) -> Date? {
        guard let productDate = productedByDate, let monthsToAdd = months, let daysToAdd = days else {
                return nil
            }
            var dateComponents = DateComponents()
            dateComponents.month = monthsToAdd
            dateComponents.day = daysToAdd
            
            return calendar.date(byAdding: dateComponents, to: productDate)
    }
    
    func expirationDateCheck(experationDate: Date?) -> Bool {
        guard let experationDate = experationDate else { return false }
        if experationDate < currentDate {
            return true
        } else {
            return false
        }
    }
    
    
    func pickerRows(from date1: Date?, to date2: Date?, daysOrMonths: DaysOrMonths) -> Int? {
        guard let date1 = date1, let date2 = date2 else { return 0 }
        var components = DateComponents()
            components = calendar.dateComponents([.month, .day], from: date1, to: date2)
        if let months = components.month, let days = components.day {
            if daysOrMonths == .days {
                return days
            } else {
                return months
            }
        } else {
            return 0
        }
    }
    
    func differenceDays(from date1: Date?, to date2: Date?) -> CGFloat {
        guard let date1 = date1, let date2 = date2 else { return 0 }
        
        let daysFromCurrentDate = calendar.dateComponents([.day], from: currentDate, to: date2)
        let daysFromProductDate = calendar.dateComponents([.day], from: date1, to: date2)
        
        guard let daysFromCurrentDate = daysFromCurrentDate.day,
              let daysFromProductDate = daysFromProductDate.day
        else { return 0 }
        
        let days = CGFloat(daysFromCurrentDate) / CGFloat(daysFromProductDate)
        return days * 100 / 100
    }
}
