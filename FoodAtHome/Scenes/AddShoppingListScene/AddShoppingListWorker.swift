//
//  AddShoppingListWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.02.2025.
//

import UIKit

class AddShoppingListWorker {
    func getImage(from foodName: String) -> UIImage {
        let image = UIImage(named: foodName) ?? UIImage()
        return image
    }
}
