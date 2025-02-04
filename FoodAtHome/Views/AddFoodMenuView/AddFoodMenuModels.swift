//
//  AddFoodMenuModels.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.12.2024.
//

import UIKit

enum AddFoodMenuModel {
    
    enum ShowFood {
        struct Request {
            let food: FoodRealm
        }
        
        struct Responce {
            let food: FoodRealm
        }
        
        struct ViewModel {
            struct DisplayedFood {
                let imageName: String
                let weight: String
                let productionDate: String
                let expirationDate: String
                let consumeUp: String
            }
            let displayedFood: DisplayedFood
        }
    }
}
