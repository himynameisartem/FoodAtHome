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
                let imageName: String
                let daysLeftIndicator: Bool
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
    
    enum showDetailFood {
        struct Request{
            
        }
        
        struct Responce {
            let foodDetails: FoodRealm
        }
        
        struct ViewModel {
            struct DiplayedDetails {
                let name: String
                let weight: String
                let unit: String
                let productionDate: String
                let expirationDate: String
                let daysLeft: String
                let distaceIndicator: CGFloat?
            }
            let DiplayedDetails: DiplayedDetails
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
