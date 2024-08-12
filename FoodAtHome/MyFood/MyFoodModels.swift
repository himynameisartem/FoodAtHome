//
//  MyFoodModels.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 12.04.2024.
//

import UIKit

enum MyFood {
    
    enum ShowMyFood {
        
        struct Request {
        }
        
        struct Response {
            let food: [FoodRealm]
        }
        
        struct ViewModel {
            struct DisplayedMyFood {
                let name: String
            }
            let displayedMyFood: [DisplayedMyFood]
        }
    }
    
    enum ShowCategories {
        
        struct Request{
        }
        
        struct Responce {
            let categories: [String]
        }
        
        struct ViewModel {
            struct DiplayedCategories {
                let name: String
                let imageName: String
            }
            let displayedCategories: [DiplayedCategories]
        }
    }
}
