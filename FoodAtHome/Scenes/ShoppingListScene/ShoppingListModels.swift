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
            }
            let displayedFood: [DisplayedFood]
        }
    }
}

