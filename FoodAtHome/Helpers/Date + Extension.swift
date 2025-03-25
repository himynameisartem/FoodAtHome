//
//  Date + Extension.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 24.03.2025.
//

import UIKit

extension Date {
    func formattedDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
}
