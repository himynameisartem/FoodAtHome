//
//  AddShoppingListModels.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.02.2025.
//

import UIKit

enum AddShoppingListModel {
    
    enum ShowFood {
        struct Request {
        }
        struct Response {
            let image: UIImage
            let weight: String?
            let unit: String
        }
        struct ViewModel {
            let image: UIImage
            let weight: String?
            let unit: String
        }
    }
    
    enum AddFood {
        struct Request {
            let weight: String
            let unit: String
        }
        struct Response {
            let alert: UIAlertController?
        }
        struct ViewModel {
            let alert: UIAlertController?
        }
    }
}

