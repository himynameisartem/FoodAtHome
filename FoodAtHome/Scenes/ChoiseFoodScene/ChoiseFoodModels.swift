//
//  ChoiseFoodModels.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2024.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum ChoiseFood {
    
    enum ShowCategoriesFood {
        struct Request {
        }
        struct Response {
            let categoriesName: [String]
        }
        struct ViewModel {
            let categoriesName: [String]

        }
    }
   
  enum ShowFood {
    struct Request {
        let category: FoodType?
        let name: String?
    }
    struct Response {
        let food: [FoodRealm]
    }
    struct ViewModel {
        struct DispalyedFood {
            let name: String
            let imageName: String
            let calories: String
        }
        let displayedFood: [DispalyedFood]
    }
  }
}
