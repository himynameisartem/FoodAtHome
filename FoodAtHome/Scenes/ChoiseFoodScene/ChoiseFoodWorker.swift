//
//  ChoiseFoodWorker.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 27.08.2024.
//

import UIKit

protocol ChoiseFoodWorkerProtocol {
    func fetchItemForAddFoodMenu(from foodName: String) -> FoodRealm
}

class ChoiseFoodWorker: ChoiseFoodWorkerProtocol {
    
    func fetchItemForAddFoodMenu(from foodName: String) -> FoodRealm {
        let responce = FoodRealm()
        DataManager.shared.fetchFoodData { food in
            guard let food = food.first(where: {$0.name == foodName}) else { return }
            responce.name = food.name
            responce.type = food.type
            responce.calories = food.calories
        }
        return responce
    }
}
