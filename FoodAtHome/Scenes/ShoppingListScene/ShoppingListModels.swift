//
//  ShoppingListModels.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

enum ShoppingListModel {
    
    enum FetchShoppingList {
        struct Request {}
        struct Response {
            let food: [FoodRealm]
        }
        struct ViewModel {
            struct DisplayedFood {
                let name: String
                let imageName: String
                let calories: String
                let isShoppingList: Bool
                let weight: String
                let unit: String
            }
            let displayedFood: [DisplayedFood]
        }
    }
    
    enum AddToMyFood {
        struct Request {
            let indexPath: IndexPath
            let completion: ((Bool) -> Void)
        }
        struct Response {
            let shouldConfirm: Bool
            let indexPath: IndexPath
            let completion: ((Bool) -> Void)
        }
        struct ViewModel {
            let alerTitle: String
            let yesActionTitle: String
            let noActionTitle: String
            let indexPath: IndexPath
            let completion: ((Bool) -> Void)
        }
    }
    
    enum ConfirmEditingFood {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {
            let isConfirm: Bool
        }
        struct ViewModel {
            let isSuccess: Bool
        }
    }
    
    enum CheckDuplicate {
        struct Request {
            let indexPath: IndexPath
            let completion: ((Bool) -> Void)
        }
        struct Response {
            let shouldConfirm: Bool
            let indexPath: IndexPath
            let completion: ((Bool) -> Void)
        }
        struct ViewModel {
            let isValid: Bool
            let indexPath: IndexPath
            let alertTitle: String?
            let alertMessage: String?
            let confirmActionTitle: String?
            let cancelActionTitle: String?
            let completion: ((Bool) -> Void)
        }
    }
    
    enum ConfirmAddToMyFood {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {
            let isConfirm: Bool
        }
        struct ViewModel {
            let isSuccess: Bool
        }
    }
    
    enum ConfirmChangeMyFood {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {
            let isConfirm: Bool
        }
        struct ViewModel {
            let isSuccess: Bool
        }
    }
    
    enum PrepareEditing {
        struct Request{
            let indexPath: IndexPath
        }
        struct Response {}
        struct ViewModel {}
    }
    
    enum DeleteFood {
        struct Request{
            let indexPath: IndexPath
        }
        struct Response {}
        struct ViewModel {}
    }
    
    enum FetchSharedShoppingList {
        struct Request {}
        struct Response {
            let sharedFood: [FoodRealm]
        }
        struct ViewModel {
            let foodList: String
        }
    }
    
    enum RemoveAllShoppingList {
        struct Request{}
        struct Response {
            let shouldConfirm: Bool
        }
        struct ViewModel {
            let alertTitle: String
            let alertMessage: String
            let confirmActionTitle: String
            let cancelActionTitle: String
        }
    }
    
    enum ConfirmRemoveAllShoppingList {
        struct Request {}
        struct Response {
            let isConfirm: Bool
        }
        struct ViewModel {
            let isSuccess: Bool
        }
    }
}

