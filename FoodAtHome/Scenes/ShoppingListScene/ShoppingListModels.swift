//
//  ShoppingListModels.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//

import UIKit

enum ShoppingListModel {
    
    enum ShowFood {
        struct Request {
        }
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
        struct Request{
            let indexPath: IndexPath
        }
        
        struct Responce {
        }
        
        struct ViewModel {
        }
    }
    
    enum EditingFood {
        struct Request{
            let indexPath: IndexPath
        }
        
        struct Responce {
        }
        
        struct ViewModel {
        }
    }
    
    enum DeleteFood {
        struct Request{
            let indexPath: IndexPath
        }
        
        struct Responce {

        }
        struct ViewModel {

        }
    }
}

