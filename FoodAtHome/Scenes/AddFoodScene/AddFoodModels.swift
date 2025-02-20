//
//  AddFoodModels.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 13.01.2025.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum AddFoodModel {
   
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
  
}
