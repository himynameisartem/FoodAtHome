//
//  StringExtensionLocalized.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 26.08.2023.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(
            self,
            tableName: "Localizable",
            bundle: .main,
            value: self,
            comment: self)
    }
}
