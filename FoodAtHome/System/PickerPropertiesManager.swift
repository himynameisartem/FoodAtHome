//
//  PickerPropertiesManager.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 23.07.2023.
//

import Foundation

let pickerArray = ["кг.", "г.", "л.", "мл.", "уп.", "шт."]

let monthsInterval = (1...120).map { String($0) }
let daysInterval = (1...365).map { String($0) }
