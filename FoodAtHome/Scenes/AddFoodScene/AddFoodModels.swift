//
//  AddFoodModels.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 13.01.2025.
//

import UIKit

enum AddFoodModel {
    
    enum ActiveField {
        case productionDate
        case expirationDate
        case consumeUp
    }
    
    enum ShowFood {
        struct Request {
        }
        struct Response {
            let food: FoodRealm
        }
        struct ViewModel {
            struct DisplayedFood {
                let image: UIImage
                let weight: String
                let productionDate: String?
                let expirationDate: String?
                let consumeUp: String?
            }
            let displayedFood: DisplayedFood
        }
    }
    
    enum DateUpdate {
        struct Request {
            let productionDate: String?
            let expirationDate: String?
            let consumeUpMonths: Int?
            let consumeUpDays: Int?
            let activeField: ActiveField
            let datePickerDate: Date?
        }
        
        struct Response {
            let productionDate: String?
            let expirationDate: String?
            let consumeUpMonths: Int?
            let consumeUpDays: Int?
        }
        
        struct ViewModel {
            let productionDate: String?
            let expirationDate: String?
            let consumeUpText: String?
        }
    }
    
    enum DatePickerValueUpdate {
        struct Request {
            let activeField: ActiveField
            let productionDate: String?
            let expirationDate: String?
            let consumeUpDate: ConsumeUp?
        }
        
        struct Response {
            let pickerCurrentValue: Date?
            let pickerMinValue: Date?
            let pickerMaxValue: Date?
            let consumeUpDate: ConsumeUp?
        }
        struct ViewModel {
            struct DisplayedValues {
                let pickerCurrentValue: Date
                let pickerMinValue: Date?
                let pickerMaxValue: Date?
                let currentMonthsPicker: Int
                let currentDaysPicker: Int
            }
            let displayedValues: DisplayedValues
        }
    }
    
    enum AddFood {
        struct Request {
            let weight: String?
            let unit: String
            let prductionDate: String?
            let expirationDate: String?
        }
        struct Response {
            let alertController: UIAlertController?
        }
        struct ViewModel {
            let alertController: UIAlertController?
        }
    }
    
}
