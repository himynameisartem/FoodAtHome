//
//  AddFoodModels.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 13.01.2025.
//

import UIKit

protocol AddFoodProtocol {
    var weight: String? { get }
    var unit: String { get }
    var prductionDate: String? { get }
    var expirationDate: String? { get }
    var view: UIView { get }
}

enum AddFoodModel {
    enum ActiveField {
        case productionDate
        case expirationDate
        case consumeUp
    }
    
    enum FetchFood {
        struct Request {}
        struct Response {
            let imageName: String
            let weight: String
            let unit: String
            let productionDate: String?
            let expirationDate: String?
            let consumeUp: String?
        }
        struct ViewModel {
            struct DisplayedFood {
                let image: UIImage
                let weight: String
                let unit: String
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
    
    enum CheckWeightField {
        struct Request {
            let weight: String?
        }
        struct Response {
            let shouldConfirm: Bool
        }
        struct ViewModel {
            let isValid: Bool
            let alertTitle: String?
            let confirmActionTitle: String?
        }
    }
    
    enum CheckParent {
        struct Request {
            let view: UIView
        }
        struct Response {
            let isEditing: Bool
        }
        struct ViewModel {
            let isValid: Bool
        }
    }
    
    enum CheckDuplicateFood {
        struct Request {}
        struct Response {
            let isDuplicate: Bool
        }
        struct ViewModel {
            let isValid: Bool
            let alertTitle: String?
            let alertMessage: String?
            let confirmActionTitle: String?
            let cancelActionTitle: String?
        }
    }
    
    enum AddFood {
        struct Request: AddFoodProtocol {
            let weight: String?
            let unit: String
            let prductionDate: String?
            let expirationDate: String?
            let view: UIView
        }
        struct Response {
            let shouldConfirm: Bool
        }
        struct ViewModel {}
    }
    
    enum ChangeFood {
        struct Request: AddFoodProtocol {
            let weight: String?
            let unit: String
            let prductionDate: String?
            let expirationDate: String?
            let view: UIView
        }
        struct Response {
            let shouldConfirm: Bool
        }
        struct ViewModel {}
    }
}
