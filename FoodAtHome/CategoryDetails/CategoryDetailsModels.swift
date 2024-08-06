//
//  CategoryDetailsModels.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.07.2024.
//

import UIKit

enum CategoryDetails {
   
  enum ShowDetails {
    struct Request {
    }
    struct Response {
        let food: [FoodRealm]
    }
    struct ViewModel {
        struct DisplayedDetails {
            let foodName: String
            let imageName: String
            let weight: String
            let calories: String
        }
        
        let displayedDetails: [DisplayedDetails]
    }
  }
  
}
