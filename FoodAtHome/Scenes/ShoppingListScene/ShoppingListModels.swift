//
//  ShoppingListModels.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 15.10.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum ShoppingList {
    
    enum ShoppingListModel {
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
            let food: FoodRealm
        }
        
        struct ViewModel {
            let food: FoodRealm
        }
    }
    
    enum ChangeFood {
        struct Request{
            let indexPath: IndexPath
        }
        
        struct Responce {
            let food: FoodRealm
        }
        
        struct ViewModel {
            let food: FoodRealm
        }
    }
    
    enum DeleteFood {
        struct Request{
            let indexPath: IndexPath
        }
        
        struct Responce {
        }
    }
}

