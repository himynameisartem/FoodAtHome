//
//  LocalizationHelper.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 04.06.2025.
//

import Foundation

struct LocalizationHelper {
    private static var reverseMapping: [String: String] = {
        guard let path = Bundle.main.path(forResource: "Localizable", ofType: "strings"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: String] else {
            return [:]
        }
        var reversed = [String: String]()
        for (eng, rus) in dict {
            reversed[rus] = eng
        }
        return reversed
    }()
    
    static func englishName(from russian: String) -> String? {
        return reverseMapping[russian]
    }
}
