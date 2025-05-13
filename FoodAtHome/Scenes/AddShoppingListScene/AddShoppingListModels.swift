//
//  AddShoppingListModels.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.02.2025.
//

import UIKit

protocol AddShoppingListItemProtocol {
    var weight: String { get }
    var unit: String { get }
}

enum AddShoppingListModel {
    
    enum ShowFood {
        struct Request {
        }
        struct Response {
            let image: UIImage
            let weight: String?
            let unit: String
        }
        struct ViewModel {
            let image: UIImage
            let weight: String?
            let unit: String
        }
    }
    
    enum CheckWeightField {
        struct Request {
            let weight: String
        }
        struct Response {
            let shouldConfirm: Bool
        }
        struct ViewModel {
            let isValid: Bool
            let aletrtTitle: String?
            let okButtonTitle: String?
        }
    }
    
    enum CheckDuplicate {
        struct Request {}
        struct Response {
            let shouldConfirm: Bool
        }
        struct ViewModel {
            let isValid: Bool
            let alertTitle: String?
            let alertMessage: String?
            let confirmActionTitle: String?
            let cancelActionTitle: String?
        }
    }
    
    enum CheckEditAction {
        struct Request {}
        struct Response {
            let isEditActionValid: Bool
        }
        struct ViewModel {
            let isValid: Bool
        }
    }
    
    enum ConfirmAddFood {
        struct Request {
            let weight: String
            let unit: String
        }
        struct Response {}
        struct ViewModel {}
    }
    
    enum ConfirmChangeFood {
        struct Request: AddShoppingListItemProtocol {
            let weight: String
            let unit: String
        }
        struct Response {}
        struct ViewModel {}
    }
    
    enum ConfirmEditAction {
        struct Request: AddShoppingListItemProtocol {
            let weight: String
            let unit: String
        }
        struct Response {}
        struct ViewModel {}
    }
}

