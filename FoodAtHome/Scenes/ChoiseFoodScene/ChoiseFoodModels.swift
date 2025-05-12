//
//  ChoiseFoodModels.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2024.
//

import UIKit

enum ChoiseFoodModel {
    
    enum FetchCategories {
        struct Request {}
        struct Response {
            let categoriesName: [String]
        }
        struct ViewModel {
            let categoriesName: [String]
        }
    }
   
  enum FetchFood {
    struct Request {
        let category: FoodType?
        let name: String?
    }
    struct Response {
        let food: [FoodItem]
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
    
    enum FetchItem {
        struct Request {
            let foodName: String
        }
        struct Response {}
        struct ViewModel {}
    }
}
