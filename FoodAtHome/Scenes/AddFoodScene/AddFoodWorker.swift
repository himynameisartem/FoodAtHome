//
//  AddFoodWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 13.01.2025.
//

import UIKit

class AddFoodWorker {
    
    func getImage(from foodName: String) -> UIImage {
        let image = UIImage(named: foodName) ?? UIImage()
        return image
    }
}
