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
            
        }
        
        struct Responce {
            let food: FoodRealm
        }
        
        struct ViewModel {
            let viewModel: FoodRealm
        }
    }
}
