//
//  CategoryDetailsInteractor.swift
//  FoodAtHome
//
//  Created by Артем Кудрявцев on 21.07.2024.
//

import UIKit

protocol CategoryDetailsBusinessLogic {
    func fetchCategories(request: CategoryDetails.ShowCategory.Request)
    func fetchCells(request: CategoryDetails.ShowFood.Request)
}

protocol CategoryDetailsDataStore {
    var food: [FoodRealm] { get set }
    var category: String { get set }
}

class CategoryDetailsInteractor: CategoryDetailsBusinessLogic, CategoryDetailsDataStore {
    
    private let worker: CategoryDetailsWorkerProtocol
    
    init (worker: CategoryDetailsWorkerProtocol) {
        self.worker = worker
    }
    
    var category = String()
    var presenter: CategoryDetailsPresentationLogic?
    var food: [FoodRealm] = []
    
    func fetchCategories(request: CategoryDetails.ShowCategory.Request) {
        let response = CategoryDetails.ShowCategory.Response(category: category)
        presenter?.presentCategory(response: response)
    }
    
    func fetchCells(request: CategoryDetails.ShowFood.Request) {
        let response = CategoryDetails.ShowFood.Response(food: food,
                                                         color: food.map { food in
            worker.getColor(food.expirationDate, food.productionDate)
        })
        presenter?.presentCells(response: response)
    }
    
}
