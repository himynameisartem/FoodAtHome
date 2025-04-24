//
//  MyFoodModels.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 12.04.2024.
//

import UIKit

enum MyFoodModel {
    
    enum FetchFoodList {
        struct Request {}
        struct Response {
            let food: [FoodRealm]
        }
        struct ViewModel {
            struct DisplayedMyFood {
                let name: String
                let imageName: String
                let daysLeftIndicator: Bool
            }
            let displayedMyFood: [DisplayedMyFood]
        }
    }
    
    enum FetchCategories {
        struct Request{}
        struct Response {
            let categories: [String]
        }
        struct ViewModel {
            struct DisplayedCategories {
                let name: String
                let imageName: String
            }
            let displayedCategories: [DisplayedCategories]
        }
    }
    
    enum FetchFoodDetails {
        struct Request{
            let indexPath: IndexPath
        }
        struct Response {
            let foodDetails: FoodRealm
        }
        struct ViewModel {
            struct DisplayedDetails {
                let name: String
                let weight: String
                let unit: String
                let productionDate: String
                let expirationDate: String
                let daysLeft: String
                let expirationProgress: CGFloat?
            }
            let displayedDetails: DisplayedDetails
        }
    }
    
    enum DeleteFood {
        struct Request{
            let indexPath: IndexPath
        }
        struct Response {}
        struct ViewModel {}
    }
    
    enum RemoveAllMyFood {
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
    
    enum ConfirmRemoveAllMyFood {
        struct Request {}
        struct Response {}
        struct ViewModel {}
    }
    
    enum FetchSharedFood {
        struct Request {}
        struct Response {
            let sharedFood: [FoodRealm]
        }
        struct ViewModel {
            let foodList: String
        }
    }
    
    enum PrepareEditing {
        struct Request {
            let indexPath: IndexPath
        }
        struct Response {}
        struct ViewModel {}
    }
}
