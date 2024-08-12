//
//  CategoryDetailsModels.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.07.2024.
//

import UIKit

enum CategoryDetails {
    
    enum ShowCategory {
        struct Request {
        }
        
        struct Responce {
            let category: String
        }
        
        struct ViewModel {
            struct DisplayedCategory {
                let categoryName: String
                let categoryImage: String
            }
            let displayedCategory: DisplayedCategory
        }
    }
   
  enum ShowFood {
    struct Request {
    }
      
    struct Response {
        let food: [FoodRealm]
    }
      
    struct ViewModel {
        struct DisplayedCells {
            let foodName: String
            let imageName: String
            let weight: String
            let calories: String
        }
        
        let displayedCells: [DisplayedCells]
    }
  }
}
