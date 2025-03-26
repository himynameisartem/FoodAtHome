//
//  StringExtensionLocalized.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 26.08.2023.
//

import UIKit

extension String {
    func localized() -> String {
        NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self)
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = (TimeZone(secondsFromGMT: 0))
        return dateFormatter.date(from: self)
    }
}
